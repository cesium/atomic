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
    organization = Organizations.get_organization!(id)

    entries = [
      %{
        name: gettext("%{name} Board", name: organization.name),
        route: Routes.board_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
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

  defp page_title(:index, organization), do: "#{organization.name} Board"
  defp page_title(:show, organization), do: "#{organization.name} Board"
  defp page_title(:edit, _organization), do: "Edit board"
end
