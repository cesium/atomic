defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Avatar
  import AtomicWeb.Components.Table
  import AtomicWeb.Components.Pagination

  alias Atomic.Accounts
  alias Atomic.Departments
  alias Atomic.Organizations
  alias Atomic.Organizations.Collaborator

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id} = params, _, socket) do
    organization = Organizations.get_organization!(organization_id)
    department = Departments.get_department!(id)

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:current_view, current_view(socket, params))
     |> assign(:page_title, department.name)
     |> assign(:organization, organization)
     |> assign(:department, department)
     |> assign(:params, params)
     |> assign(:collaborator, maybe_put_collaborator(socket, department.id))
     |> assign(list_collaborators(department.id, params))
     |> assign(
       :all_collaborators,
       Departments.list_collaborators_by_department_id(department.id, preloads: [:user])
     )
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  defp list_collaborators(id, params) do
    case Departments.list_display_collaborators(params,
           where: [department_id: id],
           preloads: [:user]
         ) do
      {:ok, {collaborators, meta}} ->
        %{collaborators: collaborators, meta: meta}

      {:error, flop} ->
        %{collaborators: [], meta: flop}
    end
  end

  @impl true
  def handle_event("collaborate", _, socket) do
    department = socket.assigns.department
    user = socket.assigns.current_user

    case Departments.create_collaborator(%{department_id: department.id, user_id: user.id}) do
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

  @impl true
  def handle_event("show-collaborators", _payload, socket) do
    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.department_show_path(
           socket,
           :show,
           socket.assigns.organization.id,
           socket.assigns.department.id,
           tab: "collaborators"
         )
     )}
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
