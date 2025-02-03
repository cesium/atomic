defmodule AtomicWeb.AnnouncementLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("delete", _params, socket) do
    Organizations.delete_announcement(socket.assigns.announcement)

    {:noreply,
     socket
     |> put_flash(:info, gettext("Announcement deleted successfully"))
     |> push_navigate(
       to: ~p"/organizations/#{socket.assigns.current_organization.id}/announcements"
     )}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    announcement = Organizations.get_announcement!(id)
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:page_title, gettext("Edit Announcements"))
     |> assign(:announcement, announcement)
     |> assign(:current_organization, organization)}
  end
end
