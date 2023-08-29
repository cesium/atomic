defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Card
  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Departments
  alias Atomic.Organizations
  alias Atomic.Organizations.Department

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    organization = Organizations.get_organization_by_slug(slug)
    {:ok, assign(socket, :departments, list_departments(organization.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, params["slug"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty, Enum.empty?(socket.assigns.departments))
     |> assign(:has_permissions, has_permissions?(socket))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    department = Departments.get_department!(id)
    {:ok, _} = Departments.delete_department(department)

    {:noreply,
     assign(socket, :departments, list_departments(socket.assigns.current_organization.id))}
  end

  defp apply_action(socket, :edit, %{"slug" => slug, "id" => id}) do
    department = Departments.get_department!(id)
    organization = Organizations.get_organization_by_slug(slug)

    if department.organization_id == organization.id do
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
    organization = Organizations.get_organization_by_slug(params["slug"])

    socket
    |> assign(:page_title, "#{organization.name}'s Departments")
    |> assign(:department, nil)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp list_departments(id) do
    Departments.list_departments_by_organization_id(id)
  end
end
