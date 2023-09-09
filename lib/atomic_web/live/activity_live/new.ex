defmodule AtomicWeb.ActivityLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities.Activity

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
      },
      %{
        name: gettext("New Activity"),
        route: Routes.activity_new_path(socket, :new, socket.assigns.current_organization)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, gettext("New Activity"))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :activities)
     |> assign(:activity, %Activity{})}
  end
end
