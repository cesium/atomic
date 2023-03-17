defmodule AtomicWeb.AssociationLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :current_user, socket.assigns.current_user)}
  end

  @impl true
  def handle_params(%{"org" => org, "id" => id}, _, socket) do
    association = Organizations.get_association!(id, [:user, :organization, :accepted_by])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:organization, org)
     |> assign(:association, association)
     |> assign(:current_user, socket.assigns.current_user)}
  end

  defp page_title(:index), do: "List Associations"
  defp page_title(:show), do: "Show Association"
  defp page_title(:edit), do: "Edit Association"
end
