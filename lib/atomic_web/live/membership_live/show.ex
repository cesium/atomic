defmodule AtomicWeb.MembershipLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => _org, "id" => id}, _, socket) do
    membership = Organizations.get_membership!(id, [:user, :organization, :created_by])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:membership, membership)}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
