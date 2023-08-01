defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Departments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    department = Departments.get_department!(id, preloads: [:activities])

    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("Department"),
        route: Routes.department_show_path(socket, :show, organization_id, id)
      }
    ]

    if department.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:current_page, :departments)
       |> assign(:breadcrumb_entries, entries)
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:department, department)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
