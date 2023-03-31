defmodule AtomicWeb.BoardLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => id}, _, socket) do
    users_organizations = list_users_organizations(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:users_organizations, users_organizations)
     |> assign(:id, id)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_organization = Organizations.get_user_organization!(id)
    {:ok, uo} = Organizations.delete_user_organization(user_organization)

    {:noreply, assign(socket, :users_organizations, list_users_organizations(uo.organization_id))}
  end

  defp list_users_organizations(id) do
    Organizations.list_users_organizations(where: [organization_id: id])
  end

  defp page_title(:index), do: "List board"
  defp page_title(:show), do: "Show board"
  defp page_title(:edit), do: "Edit board"
end
