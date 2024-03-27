defmodule AtomicWeb.DepartmentLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Organizations.Department

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"organization_id" => organization_id, "id" => id} = _params,
        _,
        %{:assigns => %{:live_action => :edit}} = socket
      ) do
    department = Departments.get_department!(id)

    {:noreply,
     socket
     |> assign(:organization_id, organization_id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, department)}
  end

  @impl true
  def handle_params(
        %{"organization_id" => organization_id} = _params,
        _,
        %{:assigns => %{:live_action => :new}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:organization_id, organization_id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, %Department{organization_id: organization_id})}
  end
end
