defmodule AtomicWeb.DepartmentLive.Show do
   use AtomicWeb, :live_view
 
   alias Atomic.Accounts
   alias Atomic.Departments
   alias Atomic.Organizations.Collaborator

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => department_id}, _, socket) do
    department = Departments.get_department!(department_id)
    sessions = Departments.get_department_sessions(department_id)

    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, organization_id)
      },
      %{
        name: department.name,
        route: Routes.department_show_path(socket, :show, organization_id, department_id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:page_title, department.name)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:department, department)
     |> assign(:sessions, sessions)
     |> assign(:collaborator, maybe_put_collaborator(socket, department_id))
     |> assign(
       :collaborators,
       Departments.list_collaborators_by_department_id(department_id, preloads: [:user])
     )
     |> assign(:has_permissions?, has_permissions?(socket))}
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
         |> push_redirect(
           to: Routes.department_index_path(socket, :index, department.organization_id)
         )}
    end
  end

  @impl true
  def handle_event("must-login", _payload, socket) do
    {:noreply,
     socket
     |> put_flash(:error, gettext("You must be logged in to follow an organization."))
     |> push_redirect(to: Routes.user_session_path(socket, :new))}
  end

  defp maybe_put_collaborator(socket, _department_id) when not socket.assigns.is_authenticated?,
    do: nil

  defp maybe_put_collaborator(socket, department_id) do
    Departments.get_department_collaborator(department_id, socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
