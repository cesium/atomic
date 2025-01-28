defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias AtomicWeb.Components.ImageUploader

  import AtomicWeb.Components.Forms

  alias Phoenix.LiveView.JS

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
     |> assign(:modal, false)
     |> assign(:has_description?, initial_description)
     |> allow_upload(:image, accept: Uploaders.Post.extension_whitelist(), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    description = Map.get(activity_params, "description", "")
    has_description = is_nil(description) || String.trim(description) == ""

    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:has_description?, not has_description)
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
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def handle_event("toggle_description_modal", _, socket) do
    {:noreply,
     socket
     |> assign(:modal, not socket.assigns.modal)}
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

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
