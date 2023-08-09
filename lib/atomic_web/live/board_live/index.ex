defmodule AtomicWeb.BoardLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Board
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => id}, _, socket) do
    board = Board.get_organization_board_by_year("2023/2024", id)
    board_departments = []

    if board do
      ^board_departments = Board.get_board_departments_by_board_id(board.id)
    end

    organization = Organizations.get_organization!(id)
    role = Organizations.get_role(socket.assigns.current_user.id, id)

    entries = [
      %{
        name: gettext("%{name} Board", name: organization.name),
        route: Routes.board_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:current_organization, organization)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:board_departments, board_departments)
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
     |> assign(:role, role)
     |> assign(:id, id)}
  end

  def handle_event("update-sorting", %{"ids" => ids}, socket) do
    ids = Enum.filter(ids, fn id -> String.length(id) > 0 end)

    ids
    |> Enum.with_index(0)
    |> Enum.each(fn {"board-department-" <> id, priority} ->
      id
      |> Board.get_board_department!()
      |> Board.update_board_department(%{priority: priority})
    end)

    {:noreply, socket}
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
