defmodule AtomicWeb.CardLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"membership_id" => id}, _, socket) do
    membership = Organizations.get_membership!(id, [:user, :organization])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:membership, membership)}
  end

  defp page_title(:show), do: "Membership Card"
end
