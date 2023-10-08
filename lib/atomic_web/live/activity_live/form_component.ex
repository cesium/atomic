defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias AtomicWeb.Components.Forms
  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: Atomic.Uploader.extensions_whitelist(), max_entries: 1)}
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    current_organization = assigns.current_organization
    speakers = Activities.list_speakers_by_organization_id(current_organization.id)

    changeset = Activities.change_activity(activity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:speakers, load_options(speakers))
     |> assign(:selected_speakers, [])
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def handle_event("toggle_option", %{"id" => id}, socket) do
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
     |> assign(:selected_speakers, Enum.filter(updated_speakers, & &1.selected))}
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

    save_activity(socket, socket.assigns.action, activity_params)
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
         |> put_flash(:info, "Activity updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    activity_params =
      activity_params
      |> Map.put("organization_id", socket.assigns.current_organization.id)

    case Activities.create_activity(activity_params, &consume_image_data(socket, &1)) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp load_options(items) do
    Enum.map(items, fn item ->
      %{
        id: item.id,
        label: item.name,
        selected: false
      }
    end)
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
end
