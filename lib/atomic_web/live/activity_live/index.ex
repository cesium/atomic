defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Activity
  alias Atomic.Organizations

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :sessions, list_sessions(params["organization_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, params["organization_id"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
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
    organization = Organizations.get_organization!(params["organization_id"])

    socket
    |> assign(:page_title, "#{organization.name}'s Activities")
    |> assign(:activity, nil)
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
    user = socket.assigns.current_user
    activities = Activities.get_user_activities(user.id)

    {:noreply, assign(socket, :activities, activities)}
  end

  defp list_sessions(organization_id) do
    Activities.list_sessions_by_organization_id(organization_id,
      preloads: [:activity, :speakers, :enrollments]
    )
  end
end
