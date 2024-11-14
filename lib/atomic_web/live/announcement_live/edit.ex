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
     |> push_navigate(to: ~p"/announcements")}
  end

  @impl true
  def handle_params(%{"organization_id" => _organization_id, "id" => id}, _, socket) do
    announcement = Organizations.get_announcement!(id)

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:page_title, gettext("Edit Announcements"))
     |> assign(:announcement, announcement)}
  end
end
