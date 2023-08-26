defmodule AtomicWeb.AnnouncementLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id} = _params, _url, socket) do
    announcement = Organizations.get_announcement!(id)

    entries = [
      %{
        name: gettext("Announcements"),
        route: Routes.announcement_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("Edit Announcements"),
        route: Routes.announcement_edit_path(socket, :edit, id, organization_id)
      }
    ]

    if organization_id == announcement.organization_id do
      {:noreply,
       socket
       |> assign(:breadcrumb_entries, entries)
       |> assign(:current_page, :activities)
       |> assign(:page_title, gettext("Edit Aannouncements"))
       |> assign(:announcement, announcement)}
    else
      raise AtomicWeb.MismatchError
    end
  end
end
