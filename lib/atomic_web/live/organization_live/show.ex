defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Organizations
  alias Atomic.Uploaders.Logo

  import AtomicWeb.Components.Calendar

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, socket |> assign(:current_user, user)}
  end

  @impl true
  def handle_params(%{"organization_id" => id}, _, socket) do
    organization = Organizations.get_organization!(id, [:departments])
    sessions = Activities.list_sessions_by_organization_id(id, [])
    departments = organization.departments

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      },
      %{
        name: gettext("%{name}", name: organization.name),
        route: Routes.organization_show_path(socket, :show, id)
      }
    ]

    mode = "month"

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, organization.name))
     |> assign(:time_zone, socket.assigns.time_zone)
     |> assign(:mode, mode)
     |> assign(:params, %{})
     |> assign(:organization, organization)
     |> assign(:sessions, sessions)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :organizations)
     |> assign(:departments, departments)
     |> assign(:following, Organizations.is_member_of?(socket.assigns.current_user, organization))}
  end

  @impl true
  def handle_event("follow", _payload, socket) do
    attrs = %{
      role: :follower,
      user_id: socket.assigns.current_user.id,
      created_by_id: socket.assigns.current_user.id,
      organization_id: socket.assigns.organization.id
    }

    current_user = socket.assigns.current_user

    case Organizations.create_membership(attrs) do
      {:ok, _organization} ->
        maybe_update_default_organization(current_user, socket.assigns.organization)

        {:noreply,
         socket
         |> put_flash(:success, "Started following " <> socket.assigns.organization.name)
         |> assign(:following, true)
         |> push_patch(
           to: Routes.organization_show_path(socket, :show, socket.assigns.organization.id)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("unfollow", _payload, socket) do
    membership =
      Organizations.get_membership_by_userid_and_organization_id!(
        socket.assigns.current_user.id,
        socket.assigns.organization.id
      )

    case Organizations.delete_membership(membership) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:success, "Stopped following " <> socket.assigns.organization.name)
         |> push_redirect(to: Routes.organization_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp maybe_update_default_organization(user, organization) do
    if user.default_organization_id == nil do
      Accounts.update_user(user, %{
        default_organization_id: organization.id
      })
    end
  end

  defp page_title(:show, organization), do: "#{organization}"
  defp page_title(:edit, organization), do: "Edit #{organization}"
end
