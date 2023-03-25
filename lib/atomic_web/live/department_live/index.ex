defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Departments.Department

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :departments, list_departments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Department")
    |> assign(:department, Departments.get_department!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Department")
    |> assign(:department, %Department{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Departments")
    |> assign(:department, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    department = Departments.get_department!(id)
    {:ok, _} = Departments.delete_department(department)

    {:noreply, assign(socket, :departments, list_departments())}
  end

  defp list_departments do
    Departments.list_departments()
  end
end
