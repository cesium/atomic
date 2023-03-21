defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => id}, _, socket) do
    memberships = Organizations.list_memberships(%{"organization_id" => id}, [:user])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:memberships, memberships)}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
