defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

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

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(list_sessions(params["organization_id"], params))
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

    {:noreply, assign(socket, list_sessions(socket.assigns.current_organization.id, %{}))}
  end

  def handle_event("open-enrollments", _payload, socket) do
    {:noreply, assign(socket, list_sessions(socket.assigns.current_organization.id, %{}))}
  end

  def handle_event("activities-enrolled", _payload, socket) do
    user = socket.assigns.current_user

    sessions =
      Activities.list_sessions_enrolled(user.id, %{page_size: 6},
        preloads: [:activity, :speakers, :enrollments, :departments]
      )

    case sessions do
      {:ok, {sessions, meta}} ->
        {:noreply, assign(socket, %{sessions: sessions, meta: meta})}

      {:error, flop} ->
        {:noreply, assign(socket, %{sessions: [], meta: flop})}
    end
  end

  defp list_sessions(id, params) do
    case Activities.list_sessions_by_organization_id(id, Map.put(params, "page_size", 6),
           preloads: [:activity, :speakers, :enrollments]
         ) do
      {:ok, {sessions, meta}} ->
        %{sessions: sessions, meta: meta}

      {:error, flop} ->
        %{sessions: [], meta: flop}
    end
  end
end
