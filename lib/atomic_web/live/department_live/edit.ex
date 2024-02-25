defmodule AtomicWeb.DepartmentLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Departments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id} = _params, _, socket) do
    department = Departments.get_department!(id)

    {:noreply,
     socket
     |> assign(:organization_id, organization_id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, department)}
  end
end
