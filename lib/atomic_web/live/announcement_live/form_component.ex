defmodule AtomicWeb.AnnouncementLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

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
     |> push_event("init-editor", %{data: announcement.content, read_only: false})}
  end

  @impl true
  def handle_event("swap-view-mode", _params, socket) do
    {:noreply, push_event(socket, "swap-view-mode", %{})}
  end

  def handle_event("save", %{"announcement" => announcement_params}, socket) do
    {:noreply,
     push_event(socket, "send-saved-data", %{params: announcement_params, selector: "1"})}
  end

  def handle_event("save-data", %{"data" => data, "params" => params}, socket) do
    save_announcement(socket, :edit, Map.put(params, "content", data))
  end

  defp save_announcement(socket, :edit, announcement_params) do
    case Organizations.update_announcement(
           socket.assigns.announcement,
           announcement_params
         ) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:success, "Announcement updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_announcement(socket, :announcement, announcement_params) do
    announcement_params =
      Map.put(announcement_params, "organization_id", socket.assigns.organization.id)

    case Organizations.create_announcement(announcement_params) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:success, "Announcement created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
