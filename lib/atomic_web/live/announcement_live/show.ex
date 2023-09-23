defmodule AtomicWeb.AnnouncementLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
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
     |> assign(:page_title, "#{announcement.title}")
     |> assign(:current_page, :announcements)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:announcement, announcement)
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
