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
  def handle_params(params, uri, %{:assigns => %{:live_action => live_action}} = socket) do
    case live_action do
      :new ->
        handle_params_new(params, uri, socket)

      :edit ->
        handle_params_edit(params, uri, socket)

      _ ->
        {:noreply, socket}
    end
  end

  def handle_params_edit(%{"organization_id" => organization_id, "id" => id} = _params, _, socket) do
    department = Departments.get_department!(id)

    {:noreply,
     socket
     |> assign(:organization_id, organization_id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, department)}
  end

  def handle_params_new(%{"organization_id" => organization_id} = _params, _, socket) do
    {:noreply,
     socket
     |> assign(:organization_id, organization_id)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, %Department{organization_id: organization_id})}
  end
end
