defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    activity = Activities.get_activity!(id, [:activity_sessions, :departments, :speakers])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      },
      %{
        name: activity.title,
        route: Routes.activity_show_path(socket, :show, activity)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, gettext("Edit Activity"))
     |> assign(
       :activity,
       Activities.get_activity!(id, [:activity_sessions, :speakers, :departments])
     )}
  end
end
