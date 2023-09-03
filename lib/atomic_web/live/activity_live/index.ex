defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      }
    ]

    sessions = list_default_sessions(socket)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Activities"))
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:sessions, sessions)
     |> assign(:empty?, Enum.empty?(sessions))
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  @impl true
  def handle_event("all", _payload, socket) do
    sessions = Activities.list_sessions(preloads: [:activity, :speakers, :enrollments])
    {:noreply, assign(socket, :sessions, sessions)}
  end

  @impl true
  def handle_event("following", _payload, socket) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    sessions =
      Enum.map(organizations, fn organization ->
        Activities.list_sessions_by_organization_id(organization.id,
          preloads: [:activity, :speakers, :enrollments]
        )
      end)

    {:noreply, assign(socket, :sessions, List.flatten(sessions))}
  end

  @impl true
  def handle_event("upcoming", _payload, socket) do
    sessions = Activities.list_upcoming_sessions(preloads: [:activity, :speakers, :enrollments])
    {:noreply, assign(socket, :sessions, sessions)}
  end

  @impl true
  def handle_event("enrolled", _payload, socket) do
    sessions =
      Activities.list_user_sessions(socket.assigns.current_user.id,
        preloads: [:activity, :speakers, :enrollments]
      )

    {:noreply, assign(socket, :sessions, sessions)}
  end

  defp list_default_sessions(socket) do
    if socket.assigns.is_authenticated? do
      organizations =
        Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

      sessions =
        Enum.map(organizations, fn organization ->
          Activities.list_sessions_by_organization_id(organization.id,
            preloads: [:activity, :speakers, :enrollments]
          )
        end)

      List.flatten(sessions)
    else
      Activities.list_sessions(preloads: [:activity, :speakers, :enrollments])
    end
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
