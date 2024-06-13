defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Uploader
  alias AtomicWeb.Components.{ImageUploader, MultiSelect}

  import AtomicWeb.Components.Forms

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    changeset = Activities.change_activity(activity)
    speakers = list_speakers(assigns)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:speakers, speakers)
     |> assign(:selected_speakers, Enum.count(speakers, & &1.selected))
     |> allow_upload(:image, accept: Uploader.extensions_whitelist(), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"activity" => activity_params}, socket) do
    speakers =
      List.foldl(socket.assigns.speakers, [], fn speaker, acc ->
        if speaker.selected do
          [speaker.id | acc]
        else
          acc
        end
      end)

    activity_params =
      activity_params
      |> Map.put("speakers", speakers)
      |> Map.put("organization_id", socket.assigns.current_organization.id)

    save_activity(socket, socket.assigns.action, activity_params)
  end

  @impl true
  def handle_event("toggle-option", %{"id" => id}, socket) do
    updated_speakers =
      Enum.map(socket.assigns.speakers, fn option ->
        if option.id == id do
          %{option | selected: !option.selected}
        else
          option
        end
      end)

    {:noreply,
     socket
     |> assign(:speakers, updated_speakers)
     |> assign(:selected_speakers, Enum.count(updated_speakers, & &1.selected))}
  end

  @impl true
  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp save_activity(socket, :new, activity_params) do
    case Activities.create_activity_with_post(activity_params, &consume_image_data(socket, &1)) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully!")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_activity(socket, :edit, activity_params) do
    case Activities.update_activity(
           socket.assigns.activity,
           activity_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully!")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp consume_image_data(socket, activity) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Activities.update_activity_image(activity, %{
        "image" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, activity}] ->
        {:ok, activity}

      _errors ->
        {:ok, activity}
    end
  end

  defp list_speakers(assigns) do
    activity = assigns.activity

    organization_speakers =
      Activities.list_speakers_by_organization_id(assigns.current_organization.id)

    Enum.map(organization_speakers, fn s ->
      selected =
        if(is_list(activity.speakers), do: Enum.member?(activity.speakers, s), else: false)

      %{
        id: s.id,
        label: s.name,
        selected: selected
      }
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
