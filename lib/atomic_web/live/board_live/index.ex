defmodule AtomicWeb.BoardLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Board
  alias Atomic.Ecto.Year
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    current_year = Year.current_year()
    board = Board.get_organization_board_by_year(current_year, organization_id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    organization = Organizations.get_organization!(organization_id)
    role = Organizations.get_role(socket.assigns.current_user.id, organization_id)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Board")}",
        route: Routes.board_index_path(socket, :index, organization_id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:page_title, "#{organization.name}'s #{gettext("Board")}")
     |> assign(:breadcrumb_entries, entries)
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:has_permissions?, has_permissions?(socket))
     |> assign(:role, role)
     |> assign(:year, current_year)}
  end

  @impl true
  def handle_event("previous-year", %{"organization-id" => organization_id}, socket) do
    year = Year.previous_year(socket.assigns.year)
    board = Board.get_organization_board_by_year(year, organization_id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    {:noreply,
     socket
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:year, year)}
  end

  @impl true
  def handle_event("next-year", %{"organization-id" => organization_id}, socket) do
    year = Year.next_year(socket.assigns.year)
    board = Board.get_organization_board_by_year(year, organization_id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    {:noreply,
     socket
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:year, year)}
  end

  @impl true
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

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
