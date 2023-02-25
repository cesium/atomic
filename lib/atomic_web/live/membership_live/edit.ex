defmodule AtomicWeb.MembershipLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_user, socket.assigns.current_user)}
  end

  @impl true
  def handle_params(%{"organization" => organization, "id" => id}, _, socket) do
    membership = Organizations.get_membership!(id, [:user, :organization, :created_by])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:organization, organization)
     |> assign(:membership, membership)
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(
       :allowed_roles,
       Organizations.roles_less_than_or_equal(socket.assigns.current_user.role)
     )}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
