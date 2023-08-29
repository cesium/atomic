defmodule AtomicWeb.AnnouncementLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug, "id" => id}, _, socket) do
    announcement = Organizations.get_announcement!(id)

    entries = [
      %{
        name: gettext("Announcement"),
        route: Routes.announcement_index_path(socket, :index, slug)
      },
      %{
        name: gettext("%{title}", title: announcement.title),
        route: Routes.announcement_show_path(socket, :show, slug, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action, announcement.title))
     |> assign(:announcement, announcement)}
  end

  defp page_title(:show, announcement), do: "Show #{announcement}"
  defp page_title(:edit, announcement), do: "Edit #{announcement}"
end
