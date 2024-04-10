defmodule AtomicWeb.DepartmentLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Organizations.Department
  alias Phoenix.LiveView.JS

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
     |> assign(:action, nil)
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
     |> assign(:action, nil)
     |> assign(:current_page, :departments)
     |> assign(:page_title, gettext("Edit Department"))
     |> assign(:department, %Department{organization_id: organization_id})}
  end

  @impl true
  def handle_event("set-action", %{"action" => action}, socket) do
    {:noreply, assign(socket, :action, action |> String.to_atom())}
  end

  @impl true
  def handle_event("clear-action", _params, socket) do
    {:noreply, assign(socket, :action, nil)}
  end

  @impl true
  def handle_event("confirm-action", _params, %{assigns: %{action: :archive}} = socket) do
    Departments.archive_department(socket.assigns.department)

    {:noreply,
     socket
     |> push_navigate(
       to: Routes.department_index_path(socket, :index, socket.assigns.organization_id)
     )
     |> put_flash(:info, gettext("Department archived successfully"))}
  end

  @impl true
  def handle_event("confirm-action", _params, %{assigns: %{action: :unarchive}} = socket) do
    Departments.unarchive_department(socket.assigns.department)

    {:noreply,
     socket
     |> push_navigate(
       to: Routes.department_index_path(socket, :index, socket.assigns.organization_id)
     )
     |> put_flash(:info, gettext("Department unarchived successfully"))}
  end

  @impl true
  def handle_event("confirm-action", _params, %{assigns: %{action: :delete}} = socket) do
    Departments.delete_department(socket.assigns.department)

    {:noreply,
     socket
     |> push_navigate(
       to: Routes.department_index_path(socket, :index, socket.assigns.organization_id)
     )
     |> put_flash(:info, gettext("Department deleted successfully"))}
  end

  defp display_action_goal_confirm_title(action) do
    case action do
      :archive ->
        gettext("Are you sure you want to archive this department?")

      :unarchive ->
        gettext("Are you sure you want to unarchive this department?")

      :delete ->
        gettext("Are you sure you want do delete this department?")
    end
  end

  defp display_action_goal_confirm_description(action, department) do
    case action do
      :archive ->
        gettext("You can always change you mind later and make it public again.")

      :unarchive ->
        gettext(
          "This will make it so that any person can view this department and their collaborators."
        )

      :delete ->
        gettext(
          "This will permanently delete %{department_name}, this action is not reversible.",
          department_name: department.name
        )
    end
  end
end
