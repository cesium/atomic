defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty
  import AtomicWeb.Components.Button

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

    departments =
      Departments.list_departments_by_organization_id(organization_id, preloads: [:organization])

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Departments")}")
     |> assign(:current_page, :departments)
     |> assign(:organization, organization)
     |> assign(:departments, departments)
     |> assign(:empty?, Enum.empty?(departments))
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
