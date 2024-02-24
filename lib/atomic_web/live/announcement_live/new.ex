defmodule AtomicWeb.AnnouncementLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations.Announcement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :announcements)
     |> assign(:page_title, gettext("New Announcement"))
     |> assign(:announcement, %Announcement{organization_id: organization_id})}
  end
end
