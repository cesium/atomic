defmodule AtomicWeb.ActivityLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Session

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    entries=
      [
        %{
          name: gettext("Activities"),
          route: Routes.activity_index_path(socket, :index)
        },
        %{
          name: gettext("New Activity"),
          route: Routes.activity_new_path(socket, :new)
        }
      ]

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, gettext("New Activity"))
     |> assign(:activity, %Activity{
       activity_sessions: [%Session{}],
       speakers: []
     })}
  end
end
