defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Departments
  alias Atomic.Organizations
  alias Atomic.Uploaders.Logo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = _params, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign(:page_title, organization.name)
     |> assign(:organization, organization)
     |> assign(:people, Organizations.list_organizations_members(organization))
     |> assign(:current_page, :organizations)
     |> assign(:organization, organization)
     |> assign(:departments, Departments.list_departments_by_organization_id(organization_id))
     |> assign(list_activities(organization_id))
     |> assign(:followers_count, Organizations.count_followers(organization_id))
     |> assign(:following?, maybe_put_following(socket, organization))
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  @impl true
  def handle_event("follow", _payload, socket) do
    attrs = %{
      role: :follower,
      user_id: socket.assigns.current_user.id,
      created_by_id: socket.assigns.current_user.id,
      organization_id: socket.assigns.organization.id
    }

    case Organizations.create_membership(attrs) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:success, "Started following " <> socket.assigns.organization.name)
         |> assign(:following?, true)
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
      Organizations.get_membership_by_user_id_and_organization_id!(
        socket.assigns.current_user.id,
        socket.assigns.organization.id
      )

    case Organizations.delete_membership(membership) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:success, "Stopped following " <> socket.assigns.organization.name)
         |> assign(:following?, false)
         |> push_patch(
           to: Routes.organization_show_path(socket, :show, socket.assigns.organization.id)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("must-login", _payload, socket) do
    {:noreply,
     socket
     |> put_flash(:error, gettext("You must be logged in to follow an organization."))
     |> push_navigate(to: Routes.user_session_path(socket, :new))}
  end

  defp list_activities(organization_id) do
    case Activities.list_activities_by_organization_id(organization_id) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp maybe_put_following(socket, _organization) when not socket.assigns.is_authenticated?,
    do: false

  defp maybe_put_following(socket, organization) do
    Organizations.is_member_of?(socket.assigns.current_user, organization)
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
end
