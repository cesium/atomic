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
    mode = Map.get(params, "mode", "month")

    {:noreply,
     socket
     |> assign(:page_title, "Calendar")
     |> assign(:current_page, :calendar)
     |> assign(:params, params)
     |> assign(:mode, mode)
     |> assign(:activities, list_activities(socket.assigns.timezone, mode, params))
     |> assign(:current_path, Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
     |> assign(:current_date, Timex.today(socket.assigns.timezone))
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
     |> assigns_week(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  @impl true
  def handle_event("previous", _, socket) do
    {:noreply,
     socket
     |> assign(
       :current_date,
       socket.assigns.beginning_of_month |> Timex.add(Duration.from_days(-1))
     )
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  @impl true
  def handle_event("present", _, socket) do
    {:noreply,
     socket
     |> assign(:current_date, Timex.today(socket.assigns.timezone))
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  @impl true
  def handle_event("next", _, socket) do
    {:noreply,
     socket
     |> assign(:current_date, socket.assigns.end_of_month |> Timex.add(Duration.from_days(1)))
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  @impl true
  def handle_event("set-mode", _, socket) do
    {:noreply,
     socket
     |> assign(:current_date, socket.assigns.end_of_month |> Timex.add(Duration.from_days(1)))
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  defp assigns_month(socket, current_path) do
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

  defp assigns_week(socket, current_path) do
    current = socket.assigns.current_date
    beginning_of_week = Timex.beginning_of_week(current)
    end_of_week = Timex.end_of_week(current)

    previous_week_date =
      current
      |> Timex.add(Duration.from_days(-7))

    next_week_date =
      current
      |> Timex.add(Duration.from_days(7))

    previous_week_day =
      previous_week_date
      |> date_to_day()

    previous_week_month =
      previous_week_date
      |> date_to_month()

    previous_week_year =
      previous_week_date
      |> date_to_year()

    next_week_day =
      next_week_date
      |> date_to_day()

    next_week_month =
      next_week_date
      |> date_to_month()

    next_week_year =
      next_week_date
      |> date_to_year()

    previous_week_path =
      build_path(current_path, %{
        mode: "week",
        day: previous_week_day,
        month: previous_week_month,
        year: previous_week_year
      })

    next_week_path =
      build_path(current_path, %{
        mode: "week",
        day: next_week_day,
        month: next_week_month,
        year: next_week_year
      })

    socket
    |> assign(beginning_of_week: beginning_of_week)
    |> assign(end_of_week: end_of_week)
    |> assign(previous_week_path: previous_week_path)
    |> assign(next_week_path: next_week_path)
  end

  defp list_activities(timezone, mode, params) do
    start = build_beggining_date(timezone, mode, params)
    finish = build_ending_date(timezone, mode, params)

    Activities.list_activities_from_to(start, finish)
  end
end
