defmodule AtomicWeb.MembershipLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    membership = Organizations.get_membership!(id, [:user, :organization, :created_by])
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name} - #{membership.user.name}")
     |> assign(:membership, membership)}
  end
end
