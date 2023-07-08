defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Departments.Department
  alias Atomic.Organizations

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :departments, list_departments(params["organization_id"]))}
  end

  @impl true
  def handle_params(%{"org" => _id} = params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Department")
    |> assign(:department, Departments.get_department!(id))
  end

  defp apply_action(socket, :new, %{"org" => id}) do
    socket
    |> assign(:page_title, "New Department")
    |> assign(:organization, Organizations.get_organization!(id))
    |> assign(:department, %Department{})
  end

  defp apply_action(socket, :index, %{"org" => id}) do
    socket
    |> assign(:page_title, "Listing Departments")
    |> assign(:organization, Organizations.get_organization!(id))
    |> assign(:department, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id, "organization_id" => organization_id}, socket) do
    department = Departments.get_department!(id)
    {:ok, _} = Departments.delete_department(department)

    {:noreply, assign(socket, :departments, list_departments(organization_id))}
  end

  defp list_departments(id) do
    Departments.list_departments_by_organization_id(id)
  end
end
