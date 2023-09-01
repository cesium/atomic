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
  def handle_params(params, _uri, socket) do
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
     |> assign(
       list_activities(socket.assigns.time_zone, mode, params, socket.assigns.current_user)
     )}
  end

  defp list_activities(time_zone, mode, params, _user) do
    current = current_from_params(time_zone, params)

    start =
      if mode == "month" do
        Timex.beginning_of_month(current) |> Timex.to_naive_datetime()
      else
        Timex.beginning_of_week(current) |> Timex.to_naive_datetime()
      end

    finish =
      if mode == "month" do
        Timex.end_of_month(current) |> Timex.to_naive_datetime()
      else
        Timex.end_of_week(current) |> Timex.to_naive_datetime()
      end

    %{
      activities: Activities.list_activities_from_to(start, finish)
    }
  end
end
