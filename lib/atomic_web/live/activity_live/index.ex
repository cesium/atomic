defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Activity
  alias Atomic.Organizations

  @impl true
  def mount(params, _session, socket) do
    organization = Organizations.get_organization_by_handle(params["handle"])
    {:ok, assign(socket, :sessions, list_sessions(organization.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, params["handle"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty, Enum.empty?(socket.assigns.sessions))
     |> assign(:has_permissions, has_permissions?(socket))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, assign(socket, :activies, list_sessions(socket.assigns.current_organization.id))}
  end

  def handle_event("open-enrollments", _payload, socket) do
    {:noreply, assign(socket, :activities, list_sessions(socket.assigns.current_organization.id))}
  end

  def handle_event("activities-enrolled", _payload, socket) do
    {:noreply, assign(socket, :activities, list_user_sessions(socket.assigns.current_user.id))}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Activities.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, params) do
    organization = Organizations.get_organization_by_handle(params["handle"])

    socket
    |> assign(:page_title, "#{organization.name}'s Activities")
    |> assign(:activity, nil)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp list_sessions(organization_id) do
    Activities.list_sessions_by_organization_id(organization_id,
      preloads: [:activity, :speakers, :enrollments]
    )
  end

  defp list_user_sessions(user_id) do
    Activities.get_user_activities(user_id)
  end
end
