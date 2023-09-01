defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Departments
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Departments")}",
        route: Routes.department_index_path(socket, :index, organization.id)
      }
    ]

    departments =
      Departments.list_departments_by_organization_id(organization_id, preloads: [:organization])

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:departments, departments)
     |> assign(:empty?, Enum.empty?(departments))
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
