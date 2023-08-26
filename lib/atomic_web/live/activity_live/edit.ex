defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      },
      %{
        name: gettext("Edit Activity"),
        route: Routes.activity_edit_path(socket, :edit, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :activities)
     |> assign(:page_title, gettext("Edit Activity"))
     |> assign(
       :activity,
       Activities.get_activity!(id, [:sessions, :speakers, :departments])
     )}
  end
end
