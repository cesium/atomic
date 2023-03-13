defmodule AtomicWeb.AssociationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => id}, _, socket) do
    associations = Organizations.list_associations(%{"organization_id" => id}, preloads: :user)
    associations_accepted = Enum.filter(associations, fn a -> a.accepted end)
    associations_pending = Enum.filter(associations, fn a -> not a.accepted end)

   {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:associations_accepted, associations_accepted)
     |> assign(:associations_pending, associations_pending)}
  end

  defp page_title(:index), do: "List Associations"
  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
