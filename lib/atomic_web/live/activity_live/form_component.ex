defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities

  import AtomicWeb.Components.{Forms, ImageUploader}

  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:card,
       accept: Uploaders.Post.extension_whitelist(),
       max_entries: 1,
       max_file_size: 10_000_000
     )}
  end

  @impl true
  def update(%{activity: activity, action: action} = assigns, socket) do
    changeset = Activities.change_activity(activity)

    initial_description =
      case action do
        :new -> false
        _ -> true
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:description_modal, false)
     |> assign(:maximum_entries_modal, false)
     |> assign(:has_max_capacity?, activity.maximum_entries)
     |> assign(:has_description?, initial_description)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    description = Map.get(activity_params, "description", "")
    capacity = Map.get(activity_params, "maximum_entries", "")
    has_description = is_nil(description) || String.trim(description) == ""
    capacity_field_empty = is_nil(capacity) || String.trim(capacity) == ""

    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:has_description?, not has_description)
     |> assign(:has_max_capacity?, not capacity_field_empty)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("save", %{"activity" => activity_params}, socket) do
    activity_params =
      activity_params
      |> Map.put("organization_id", socket.assigns.current_organization.id)

    save_activity(socket, socket.assigns.action, activity_params)
  end

  @impl true
  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :card, ref)}
  end

  @impl true
  def handle_event("toggle_description_modal", _, socket) do
    {:noreply,
     socket
     |> assign(:description_modal, not socket.assigns.description_modal)}
  end

  @impl true
  def handle_event("toggle_maximum_entries_modal", _, socket) do
    {:noreply,
     socket
     |> assign(:maximum_entries_modal, not socket.assigns.maximum_entries_modal)}
  end

  @impl true
  def handle_event("remove_max_capacity", _, socket) do
    {:noreply,
     socket
     |> assign(:has_max_capacity?, false)
     |> assign(:maximum_entries_modal, not socket.assigns.maximum_entries_modal)}
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
    results =
      [:card]
      |> Enum.map(&consume_image_entry(socket, activity, &1))
      |> List.flatten()

    if Enum.any?(results, fn result -> match?({:error, _}, result) end) do
      {:error, results}
    else
      {:ok, activity}
    end
  end

  defp consume_image_entry(socker, activity, field) do
    consume_uploaded_entries(socker, field, fn %{path: path}, entry ->
      case Activities.update_activity_image(activity, %{
             "#{field}" => %Plug.Upload{
               content_type: entry.client_type,
               filename: entry.client_name,
               path: path
             }
           }) do
        {:ok, updated_activity} ->
          {:ok, updated_activity}

        {:error, _changeset} ->
          {:error, field}
      end
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
