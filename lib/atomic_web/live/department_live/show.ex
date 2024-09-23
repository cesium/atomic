defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Avatar, Dropdown, Gradient, Table, Pagination, Modal}

  alias Atomic.Accounts
  alias Atomic.Departments
  alias Atomic.Organizations
  alias Atomic.Organizations.Collaborator
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"organization_id" => organization_id, "id" => id} = params) do
    organization = Organizations.get_organization!(organization_id)
    department = Departments.get_department!(id)

    has_permissions = has_permissions?(socket, organization_id)

    if department.archived && !has_permissions do
      raise Ecto.NoResultsError, queryable: Atomic.Organizations.Department
    else
      socket
      |> assign(:current_page, :departments)
      |> assign(:current_view, current_view(socket, params))
      |> assign(:page_title, department.name)
      |> assign(:organization, organization)
      |> assign(:department, department)
      |> assign(:params, params)
      |> assign(:current_collaborator, maybe_put_collaborator(socket, department.id))
      |> assign(list_collaborators(department.id, params, has_permissions))
      |> assign(
        :all_collaborators,
        Departments.list_department_collaborators(department.id,
          preloads: [:user],
          where: [accepted: true]
        )
      )
      |> assign(:has_permissions?, has_permissions)
    end
  end

  defp apply_action(
         socket,
         :edit_collaborator,
         %{
           "organization_id" => organization_id,
           "id" => department_id,
           "collaborator_id" => collaborator_id
         } = params
       ) do
    organization = Organizations.get_organization!(organization_id)
    department = Departments.get_department!(department_id)
    collaborator = Departments.get_collaborator!(collaborator_id, preloads: [:user])

    has_permissions = has_permissions?(socket, organization_id)

    socket
    |> assign(:current_page, :departments)
    |> assign(:current_view, current_view(socket, params))
    |> assign(:page_title, department.name)
    |> assign(:organization, organization)
    |> assign(:department, department)
    |> assign(:collaborator, collaborator)
    |> assign(list_collaborators(department.id, params, has_permissions))
    |> assign(
      :all_collaborators,
      Departments.list_department_collaborators(department.id,
        preloads: [:user],
        where: [accepted: true]
      )
    )
    |> assign(:params, params)
    |> assign(:has_permissions?, has_permissions)
  end

  defp list_collaborators(id, params, has_permissions) do
    if has_permissions do
      # If the user has permissions, list all collaborators
      list_collaborators_paginated(params, department_id: id)
    else
      # If the user does not have permissions, list only accepted collaborators
      list_collaborators_paginated(params, department_id: id, accepted: true)
    end
  end

  defp list_collaborators_paginated(params, filter) do
    case Departments.list_display_collaborators(params,
           where: filter,
           preloads: [:user]
         ) do
      {:ok, {collaborators, meta}} ->
        %{collaborators: collaborators, meta: meta}

      {:error, flop} ->
        %{collaborators: [], meta: flop}
    end
  end

  @impl true
  def handle_info({:change_collaborator, %{status: status, message: message}}, socket) do
    {:noreply,
     socket
     |> put_flash(status, message)
     |> assign(:live_action, :show)
     |> push_patch(
       to:
         Routes.department_show_path(
           socket,
           :show,
           socket.assigns.organization,
           socket.assigns.department,
           Map.delete(socket.assigns.params, "collaborator_id")
         )
     )}
  end

  @impl true
  def handle_event("collaborate", _, socket) do
    department = socket.assigns.department
    user = socket.assigns.current_user

    case Departments.request_collaborator_access(user, department) do
      {:ok, %Collaborator{} = collaborator} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Applied to collaborate successfully."))
         |> assign(:collaborator, collaborator)
         |> push_patch(
           to:
             Routes.department_show_path(socket, :show, department.organization_id, department.id)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(
           :error,
           "There was an error while trying to apply for this department. Please try again!"
         )
         |> push_navigate(
           to: Routes.department_index_path(socket, :index, department.organization_id)
         )}
    end
  end

  @impl true
  def handle_event("must-login", _payload, socket) do
    {:noreply,
     socket
     |> put_flash(:error, gettext("You must be logged in to follow an organization."))
     |> push_navigate(to: Routes.user_session_path(socket, :new))}
  end

  defp maybe_put_collaborator(socket, _department_id) when not socket.assigns.is_authenticated?,
    do: nil

  defp maybe_put_collaborator(socket, department_id) do
    Departments.get_department_collaborator(department_id, socket.assigns.current_user.id)
  end

  defp has_permissions?(socket, _organization_id) when not socket.assigns.is_authenticated?,
    do: false

  defp has_permissions?(socket, _organization_id)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end

  defp current_view(_socket, params) when is_map_key(params, "tab"), do: params["tab"]

  defp current_view(_socket, _params), do: "show"
end
