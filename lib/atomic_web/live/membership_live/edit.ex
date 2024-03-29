defmodule AtomicWeb.MembershipLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_user, socket.assigns.current_user)}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    membership = Organizations.get_membership!(id, [:user, :organization, :created_by])
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign(:page_title, "Edit Membership")
     |> assign(:current_page, :memberships)
     |> assign(:organization, organization)
     |> assign(:membership, membership)
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(
       :allowed_roles,
       Organizations.roles_less_than_or_equal(socket.assigns.current_user.role)
     )}
  end
end
