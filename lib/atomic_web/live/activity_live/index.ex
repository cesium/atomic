defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Activities.Activity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :activities, list_activities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries=
      [
        %{
          name: gettext("Activities"),
          route: Routes.activity_index_path(socket, :index)
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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, assign(socket, :activies, list_activities())}
  end

  defp list_activities do
    Activities.list_activities(
      preloads: [:departments, :activity_sessions, :enrollments, :instructors]
    )
  end
end
