defmodule AtomicWeb.BoardLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => id}, _, socket) do
    users_organizations = list_users_organizations(id)

    entries = [
      %{
        name: gettext("Users Organizations"),
        route: Routes.board_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:users_organizations, users_organizations)
     |> assign(:id, id)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_organization = Organizations.get_user_organization!(id)
    {:ok, user_org} = Organizations.delete_user_organization(user_organization)

    {:noreply,
     assign(socket, :users_organizations, list_users_organizations(user_org.organization_id))}
  end

  defp list_users_organizations(id) do
    Organizations.list_users_organizations(where: [organization_id: id])
  end

  defp page_title(:index), do: "List board"
  defp page_title(:show), do: "Show board"
  defp page_title(:edit), do: "Edit board"
end
