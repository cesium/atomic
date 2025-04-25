defmodule AtomicWeb.AnnouncementLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Empty, Pagination}
  import AtomicWeb.AnnouncementLive.Components.AnnouncementCard
  import AtomicWeb.LiveHelpers

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = params, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign_page_metadata(:announcements)
     |> assign(:current_page, :announcements)
     |> assign(:organization, organization)
     |> assign(:params, params)
     |> assign(:has_permissions?, has_permissions?(socket))
     |> assign(list_announcements_by_organization(socket, params, organization_id))
     |> then(fn complete_socket ->
       assign(complete_socket, :empty?, Enum.empty?(complete_socket.assigns.announcements))
     end)}
  end

  defp list_announcements_by_organization(_socket, params, organization_id) do
    case Organizations.list_announcements_by_organization_id(organization_id, params,
           preloads: [:organization]
         ) do
      {:ok, {announcements, meta}} ->
        %{announcements: announcements, meta: meta}

      {:error, flop} ->
        %{announcements: [], meta: flop}
    end
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    has_current_organization?(socket) and
      (Accounts.has_permissions_inside_organization?(
         socket.assigns.current_user.id,
         socket.assigns.current_organization.id
       ) or Accounts.has_master_permissions?(socket.assigns.current_user.id))
  end

  defp has_current_organization?(socket) do
    is_map_key(socket.assigns, :current_organization) and
      not is_nil(socket.assigns.current_organization)
  end
end
