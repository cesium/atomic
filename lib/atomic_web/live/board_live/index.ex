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
  def handle_params(%{"organization_id" => id}, _, socket) do
    board = Board.get_organization_board_by_year(Year.current_year(), id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    organization = Organizations.get_organization!(id)
    role = Organizations.get_role(socket.assigns.current_user.id, id)

    entries = [
      %{
        name: gettext("%{name}'s Board", name: organization.name),
        route: Routes.board_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:current_organization, organization)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:has_permissions?, has_permissions?(socket))
     |> assign(:board_departments, board_departments)
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
     |> assign(:role, role)
     |> assign(:year, Year.current_year())
     |> assign(:id, id)}
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

  @impl true
  def handle_event("previous_year", %{"organization-id" => organization_id}, socket) do
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
  def handle_event("next_year", %{"organization-id" => organization_id}, socket) do
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

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp page_title(:index, organization), do: "#{organization.name}'s Board"
  defp page_title(:show, organization), do: "#{organization.name}'s Board"
  defp page_title(:edit, _organization), do: "Edit board"
end
