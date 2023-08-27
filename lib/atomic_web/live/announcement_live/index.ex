defmodule AtomicWeb.AnnouncementLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Announcement
  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Organizations.Announcement

  @impl true
  def mount(%{"handle" => handle}, _session, socket) do
    organization = Organizations.get_organization_by_handle(handle)

    socket =
      socket
      |> assign(:organization, organization)
      |> assign(:announcements, list_announcements(organization.id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Announcement"),
        route: Routes.announcement_index_path(socket, :index, params["handle"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :announcements)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty, Enum.empty?(socket.assigns.announcements))
     |> assign(:has_permissions, has_permissions?(socket))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    announcement = Organizations.get_announcement!(id)
    {:ok, _} = Organizations.delete_announcement(announcement)

    {:noreply,
     socket
     |> assign(:announcement, list_announcements(announcement.organization_id))}
  end

  defp apply_action(socket, :edit, %{"organization_id" => organization_id, "id" => id}) do
    announcement = Organizations.get_announcement!(id)

    if announcement.organization_id == organization_id do
      socket
      |> assign(:page_title, "Edit Announcement")
      |> assign(:announcement, Organizations.get_announcement!(id))
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Announcement")
    |> assign(:announcement, %Announcement{})
  end

  defp apply_action(socket, :index, params) do
    organization = Organizations.get_organization_by_handle(params["handle"])

    socket
    |> assign(:page_title, "#{organization.name}'s Announcement")
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp list_announcements(organization_id) do
    Organizations.list_published_announcements_by_organization_id(organization_id, [:organization])
  end
end
