defmodule AtomicWeb.AnnouncementLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Announcement
  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    entries = [
      %{
        name: gettext("Announcements"),
        route: Routes.announcement_index_path(socket, :index)
      }
    ]

    announcements = list_default_announcements(socket)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Announcements"))
     |> assign(:current_page, :announcements)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:announcements, announcements)
     |> assign(:empty?, Enum.empty?(announcements))
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  @impl true
  def handle_event("all", _payload, socket) do
    announcements = Organizations.list_published_announcements(preloads: [:organization])

    {:noreply, assign(socket, :announcements, announcements)}
  end

  @impl true
  def handle_event("following", _payload, socket) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    announcements =
      Enum.map(organizations, fn organization ->
        Organizations.list_announcements_by_organization_id(organization.id,
          preloads: [:organization]
        )
      end)

    {:noreply, assign(socket, :announcements, List.flatten(announcements))}
  end

  defp list_default_announcements(socket) do
    if socket.assigns.is_authenticated? do
      organizations =
        Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

      announcements =
        Enum.map(organizations, fn organization ->
          Organizations.list_announcements_by_organization_id(organization.id,
            preloads: [:organization]
          )
        end)

      List.flatten(announcements)
    else
      Organizations.list_announcements(preloads: [:organization])
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
