defmodule AtomicWeb.MembershipLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug, "id" => _id}, _, socket) do
    organization = Organizations.get_organization_by_slug(slug)
    membership = Organizations.get_membership!(organization.id, socket.assigns.current_user.id)
    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name} - #{membership.user.name}")
     |> assign(:membership, membership)}
  end
end
