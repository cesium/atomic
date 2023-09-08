defmodule AtomicWeb.CalendarLive.Show do
  @moduledoc false
  use AtomicWeb, :live_view

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.Calendar

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    mode = default_mode(params)

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
     |> assign(:activities, list_activities(socket.assigns.timezone, mode, params))}
  end

  defp list_activities(timezone, mode, params) do
    start = build_beggining_date(timezone, mode, params)
    finish = build_ending_date(timezone, mode, params)

    Activities.list_activities_from_to(start, finish)
  end

  defp default_mode(params) when is_map_key(params, "mode"), do: params["mode"]

  defp default_mode(_params), do: "month"
end
