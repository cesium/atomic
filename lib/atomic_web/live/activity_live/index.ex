defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Activity
  alias Atomic.Organizations

  import AtomicWeb.Components.Pagination

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, params["organization_id"])
      }
    ]

    activities_listing = list_activities(params["organization_id"], params)

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(activities_listing)
     |> assign(:empty, Enum.empty?(activities_listing.activities))
     |> assign(:has_permissions, has_permissions?(socket))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, assign(socket, list_activities(socket.assigns.current_organization.id))}
  end

  def handle_event("open-enrollments", _payload, socket) do
    {:noreply, assign(socket, list_activities(socket.assigns.current_organization.id))}
  end

  def handle_event("activities-enrolled", _payload, socket) do
    user = socket.assigns.current_user

    activites =
      Activities.list_activities_enrolled(user.id, %{page_size: 6},
        preloads: [:speakers, :departments]
      )

    case activites do
      {:ok, {activites, meta}} ->
        {:noreply, assign(socket, %{activites: activites, meta: meta})}

      {:error, flop} ->
        {:noreply, assign(socket, %{activites: [], meta: flop})}
    end
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

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp list_activities(id, params \\ %{}) do
    case Activities.list_activities_by_organization_id(id, Map.put(params, "page_size", 6),
          preloads: [:speakers, :enrollments]
        ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}
      {:error, flop} ->
        %{sessions: [], meta: flop}
    end
  end

  defp list_user_activities(user_id) do
    Activities.get_user_activities(user_id)
  end
end
