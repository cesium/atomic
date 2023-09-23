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
  def handle_params(%{"slug" => slug}, _, socket) do
    organization = Organizations.get_organization_by_slug(slug)
    board = Board.get_organization_board_by_year(Year.current_year(), organization.id)

    board_departments =
      case board do
        nil -> []
        _ -> Board.get_board_departments_by_board_id(board.id)
      end

    role = Organizations.get_role(socket.assigns.current_user.id, organization.id)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Board")}",
        route: Routes.board_index_path(socket, :index, organization.id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :board)
     |> assign(:page_title, "#{organization.name}'s #{gettext("Board")}")
     |> assign(:breadcrumb_entries, entries)
     |> assign(:board_departments, board_departments)
     |> assign(:empty?, Enum.empty?(board_departments))
     |> assign(:has_permissions?, has_permissions?(socket, organization.id))
     |> assign(:role, role)
     |> assign(:year, Year.current_year())
     |> assign(:id, organization.id)}
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

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
