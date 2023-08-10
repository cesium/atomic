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

    if membership.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action, organization))
       |> assign(:membership, membership)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:index, organization), do: "#{organization.name}'s Memberships"
  defp page_title(:show, organization), do: "#{organization.name}'s Membership"
  defp page_title(:edit, _), do: "Edit membership"
end
