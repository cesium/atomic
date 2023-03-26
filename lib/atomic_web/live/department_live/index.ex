defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.Department

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization" => id}, _url, socket) do
    organization = Organizations.get_organization!(id, [:departments])

    departments =
      Organizations.list_departments([where: [organization_id: id]])

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      },
      %{
        name: organization.name,
        route: Routes.organization_show_path(socket, :show, id)
      },
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, organization.name)
     |> assign(:organization, organization)
     |> assign(:departments, departments)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Department")
    |> assign(:department, Organizations.get_department!(id))
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
    department = Organizations.get_department!(id)
    {:ok, _} = Organizations.delete_department(department)

    {:noreply, assign(socket, :departments, list_departments())}
  end

  defp list_departments do
    Organizations.list_departments()
  end
end
