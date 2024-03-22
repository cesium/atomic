defmodule AtomicWeb.DepartmentLive.Edit do
  @moduledoc false
  alias Atomic.Organizations.Organization
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_name" => organization_name, "id" => id} = _params, _, socket) do
    department = Departments.get_department!(id)
    organization = Organizations.get_organization_by_name!(organization_name)

    {:noreply,
     socket
     |> assign(:organization_id, organization.id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, department)}
  end
end
