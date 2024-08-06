defmodule AtomicWeb.BoardLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty
  import AtomicWeb.Components.Avatar
  import AtomicWeb.Components.Board
  import AtomicWeb.Components.Button
  import AtomicWeb.Components.Icon
  import AtomicWeb.Components.Modal

  alias Atomic.Accounts
  alias Atomic.Board
  alias Atomic.Ecto.Year
  alias Atomic.Organizations
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = params, _, socket) do
    board_id = Map.get(params, "id")
    department_id = Map.get(params, "department_id")

    current_year = Year.current_year()
    boards = Board.list_boards_by_organization_id(organization_id)

    board =
      case board_id do
        nil -> Board.get_organization_board_by_year(current_year, organization_id)
        _ -> Board.get_board!(board_id)
      end

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    organization = Organizations.get_organization!(organization_id)
    role = Organizations.get_role(socket.assigns.current_user.id, organization_id)

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:page_title, "#{organization.name}'s #{gettext("Board")}")
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))
     |> assign(:organization, organization)
     |> assign(:role, role)
     |> assign(:boards, boards)
     |> assign(:board, board)
     |> assign(:params, params)
     |> assign(:year, current_year)
     |> assign(:department_id, department_id)}
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
  def handle_event("update-selected-board", %{"id" => id}, socket) do
    board = Board.get_board!(id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    {:noreply,
     socket
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> push_patch(to: Routes.board_index_path(socket, :show, socket.assigns.organization.id, id))}
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
  def handle_info({:change_collaborator, %{status: status, message: message}}, socket) do
    {:noreply,
     socket
     |> put_flash(status, message)
     |> assign(:live_action, :show)
     |> push_patch(
       to:
         Routes.department_show_path(
           socket,
           :show,
           socket.assigns.organization,
           socket.assigns.department,
           Map.delete(socket.assigns.params, "collaborator_id")
         )
     )}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
