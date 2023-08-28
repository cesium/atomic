defmodule AtomicWeb.CalendarLive.Show do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.Calendar

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    mode = params["mode"] || "month"

    entries = [
      %{
        name: gettext("Calendar"),
        route: Routes.calendar_show_path(socket, :show)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, "Calendar")
     |> assign(:current_page, :calendar)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:params, params)
     |> assign(:mode, mode)
     |> assign(:sessions, list_sessions(socket.assigns.timezone, mode, params))}
  end

  defp list_sessions(timezone, mode, params) do
    start = build_beggining_date(timezone, mode, params)
    finish = build_ending_date(timezone, mode, params)
    Activities.list_sessions_from_to(start, finish, preloads: [:activity])
  end
end
