defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Card
  import AtomicWeb.Components.Empty
  alias Atomic.Departments
  alias Atomic.Organizations
  alias Atomic.Organizations.Department

  @impl true
  def mount(%{"organization_id" => organization_id}, _session, socket) do
    {:ok, assign(socket, :departments, list_departments(organization_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, params["organization_id"])
      }
    ]

    empty =
      Enum.empty?(socket.assigns.departments) and
        (Organizations.get_role(
           socket.assigns.current_user.id,
           socket.assigns.current_organization.id
         ) in [:owner, :admin] || socket.assigns.current_user.role in [:admin]) and
        socket.assigns.live_action not in [:new, :edit]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty, empty)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"organization_id" => organization_id, "id" => id}) do
    department = Departments.get_department!(id)

    if department.organization_id == organization_id do
      socket
      |> assign(:page_title, "Edit Department")
      |> assign(:department, Departments.get_department!(id))
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Department")
    |> assign(:department, %Department{})
  end

  defp apply_action(socket, :index, params) do
    organization = Organizations.get_organization!(params["organization_id"])

    socket
    |> assign(:page_title, "#{organization.name}'s Departments")
    |> assign(:department, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    department = Departments.get_department!(id)
    {:ok, _} = Departments.delete_department(department)

    {:noreply,
     assign(socket, :departments, list_departments(socket.assigns.current_organization.id))}
  end

  defp list_departments(id) do
    Departments.list_departments_by_organization_id(id)
  end
end
