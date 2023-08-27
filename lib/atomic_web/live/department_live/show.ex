defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"handle" => handle, "id" => id}, _, socket) do
    department = Departments.get_department!(id)
    sessions = Departments.get_department_sessions(department.id)
    collaborator = Departments.get_collaborator!(socket.assigns.current_user.id, department.id)

    entries = [
      %{
        name: gettext("Departments"),
        route: Routes.department_index_path(socket, :index, handle)
      },
      %{
        name: gettext("%{name}", name: department.name),
        route: Routes.department_show_path(socket, :show, handle, id)
      }
    ]

    organization = Organizations.get_organization_by_handle(handle)

    if department.organization_id == organization.id do
      {:noreply,
       socket
       |> assign(:current_page, :departments)
       |> assign(:breadcrumb_entries, entries)
       |> assign(:page_title, page_title(socket.assigns.live_action, department.name))
       |> assign(:department, department)
       |> assign(:sessions, sessions)
       |> assign(:collaborator, collaborator)
       |> assign(
         :collaborators,
         Departments.list_collaborators_by_department_id(department.id, preloads: [:user])
       )}
    else
      raise AtomicWeb.MismatchError
    end
  end

  @impl true
  def handle_event("collaborate", _, socket) do
    department = socket.assigns.department
    user = socket.assigns.current_user

    case Departments.create_collaborator(%{department_id: department.id, user_id: user.id}) do
      {:ok, _collaborator} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Applied to collaborate successfully."))
         |> push_redirect(
           to: Routes.department_index_path(socket, :index, department.organization_id)
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(
           :error,
           "There was an error while trying to apply for this organization. Please try again!"
         )
         |> push_redirect(
           to: Routes.department_index_path(socket, :index, department.organization_id)
         )}
    end
  end

  defp page_title(:show, department), do: "Show #{department}"
  defp page_title(:edit, department), do: "Edit #{department}"
end
