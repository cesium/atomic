defmodule AtomicWeb.CalendarLive.Show do
  @moduledoc false
  use AtomicWeb, :live_view

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.CalendarMonth
  import AtomicWeb.Components.CalendarWeek
  import AtomicWeb.Components.Dropdown

  alias Atomic.Activities
  alias Timex.Duration

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    mode = default_mode(params)

    {:noreply,
     socket
     |> assign(:page_title, "Calendar")
     |> assign(:current_page, :calendar)
     |> assign(:params, params)
     |> assign(:mode, mode)
     |> assign(:activities, list_activities(socket.assigns.timezone, mode, params))
     |> assign(:current_path, Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
     |> assign(:current_date, Timex.today(socket.assigns.timezone))
     |> assigns_month(
       Routes.calendar_show_path(AtomicWeb.Endpoint, :show),
       socket.assigns.timezone,
       params
     )}
  end

  @impl true
  def handle_event("previous", _, socket) do
    {:noreply,
     socket
     |> assign(
       :current_date,
       socket.assigns.beginning_of_month |> Timex.add(Duration.from_days(-1))
     )
     |> assigns_month(
       Routes.calendar_show_path(AtomicWeb.Endpoint, :show),
       socket.assigns.timezone,
       socket.assigns.params
     )}
  end

  @impl true
  def handle_event("present", _, socket) do
    {:noreply,
     socket
     |> assign(:current_date, Timex.today(socket.assigns.timezone))
     |> assigns_month(
       Routes.calendar_show_path(AtomicWeb.Endpoint, :show),
       socket.assigns.timezone,
       socket.assigns.params
     )}
  end

  @impl true
  def handle_event("next", _, socket) do
    {:noreply,
     socket
     |> assign(:current_date, socket.assigns.end_of_month |> Timex.add(Duration.from_days(1)))
     |> assigns_month(
       Routes.calendar_show_path(AtomicWeb.Endpoint, :show),
       socket.assigns.timezone,
       socket.assigns.params
     )}
  end

  defp assigns_month(socket, current_path, timezone, params) do
    current = socket.assigns.current_date
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    last_day_previous_month =
      beginning_of_month
      |> Timex.add(Duration.from_days(-1))

    first_day_next_month =
      end_of_month
      |> Timex.add(Duration.from_days(1))

    previous_month =
      last_day_previous_month
      |> date_to_month()

    next_month =
      first_day_next_month
      |> date_to_month()

    previous_month_year =
      last_day_previous_month
      |> date_to_year()

    next_month_year =
      first_day_next_month
      |> date_to_year()

    previous_month_path =
      build_path(current_path, %{mode: "month", month: previous_month, year: previous_month_year})

    next_month_path =
      build_path(current_path, %{mode: "month", month: next_month, year: next_month_year})

    socket
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(end_of_month: end_of_month)
    |> assign(previous_month_path: previous_month_path)
    |> assign(next_month_path: next_month_path)
  end

  defp list_activities(timezone, mode, params) do
    start = build_beggining_date(timezone, mode, params)
    finish = build_ending_date(timezone, mode, params)

    Activities.list_activities_from_to(start, finish)
  end

  defp default_mode(params) when is_map_key(params, "mode"), do: params["mode"]

  defp default_mode(_params), do: "month"
end
