defmodule AtomicWeb.AnnouncementLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations
  alias AtomicWeb.Components.ImageUploader

  import AtomicWeb.Components.Forms

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{announcement: announcement} = assigns, socket) do
    changeset = Organizations.change_announcement(announcement)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image, accept: Uploaders.Post.extension_whitelist(), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"announcement" => announcement_params}, socket) do
    changeset =
      socket.assigns.announcement
      |> Organizations.change_announcement(announcement_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"announcement" => announcement_params}, socket) do
    save_announcement(socket, socket.assigns.action, announcement_params)
  end

  @impl true
  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp save_announcement(socket, :edit, announcement_params) do
    case Organizations.update_announcement(
           socket.assigns.announcement,
           announcement_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:success, "Announcement updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_announcement(socket, :new, announcement_params) do
    announcement_params =
      Map.put(announcement_params, "organization_id", socket.assigns.organization.id)

    case Organizations.create_announcement_with_post(
           announcement_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:success, "Announcement created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp consume_image_data(socket, announcement) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Organizations.update_announcement_image(announcement, %{
        "image" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, announcement}] ->
        {:ok, announcement}

      _errors ->
        {:ok, announcement}
    end
  end
end
