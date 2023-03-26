defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization" => organization_id, "id" => id}, _, socket) do
    department = Organizations.get_department!(id, preloads: :activities)

    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, organization_id)
      },
      %{
        name: department.name,
        route: Routes.department_show_path(socket, :show, organization_id, department)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:department, department)}
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
