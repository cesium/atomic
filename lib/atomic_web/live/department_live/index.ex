defmodule AtomicWeb.DepartmentLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Departments
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok , socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    organization = Organizations.get_organization_by_slug(slug)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Departments")}",
        route: Routes.department_index_path(socket, :index, organization.id)
      }
    ]

    departments =
      Departments.list_departments_by_organization_id(organization.id, preloads: [:organization])

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Departments")}")
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organization, organization)
     |> assign(:departments, departments)
     |> assign(:empty?, Enum.empty?(departments))
     |> assign(:has_permissions?, has_permissions?(socket, organization.id))}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
