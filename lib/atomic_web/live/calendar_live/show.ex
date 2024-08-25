defmodule AtomicWeb.CalendarLive.Show do
  @moduledoc false
  use AtomicWeb, :live_view

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.CalendarMonth
  import AtomicWeb.Components.CalendarWeek
  import AtomicWeb.Components.Dropdown

  alias Atomic.Activities
  alias Atomic.Organizations
  alias Timex.Duration

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    mode = Map.get(params, "mode", "month")
    current_date = Map.get(socket.assigns, :current_date, Timex.today(socket.assigns.timezone))

    {:noreply,
     socket
     |> assign(:page_title, "Calendar")
     |> assign(:current_page, :calendar)
     |> assign(:params, params)
     |> assign(:mode, mode)
     |> assign(
       :activities,
       list_activities(socket.assigns.timezone, mode, current_date, socket.assigns.current_user)
     )
     |> assign(:current_path, Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
     |> assign(:current_date, current_date)
     |> assigns_month(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
     |> assigns_week(Routes.calendar_show_path(AtomicWeb.Endpoint, :show))}
  end

  @impl true
  def handle_event("previous", _, socket) do
    new_date =
      if socket.assigns.mode == "week" do
        socket.assigns.current_date |> Timex.add(Duration.from_days(-7))
      else
        socket.assigns.beginning_of_month |> Timex.add(Duration.from_days(-1))
      end

    {:noreply,
     socket
     |> assign(
       :current_date,
       new_date
     )
     |> assign(
       :activities,
       list_activities(
         socket.assigns.timezone,
         socket.assigns.mode,
         new_date,
         socket.assigns.current_user
       )
     )
     |> assigns_dates()}
  end

  @impl true
  def handle_event("present", _, socket) do
    new_date = Timex.today(socket.assigns.timezone)

    {:noreply,
     socket
     |> assign(:current_date, new_date)
     |> assign(
       :activities,
       list_activities(
         socket.assigns.timezone,
         socket.assigns.mode,
         new_date,
         socket.assigns.current_user
       )
     )
     |> assigns_dates()}
  end

  @impl true
  def handle_event("next", _, socket) do
    new_date =
      if socket.assigns.mode == "week" do
        socket.assigns.current_date |> Timex.add(Duration.from_days(7))
      else
        socket.assigns.end_of_month |> Timex.add(Duration.from_days(1))
      end

    {:noreply,
     socket
     |> assign(:current_date, new_date)
     |> assign(
       :activities,
       list_activities(
         socket.assigns.timezone,
         socket.assigns.mode,
         new_date,
         socket.assigns.current_user
       )
     )
     |> assigns_dates()}
  end

  @impl true
  def handle_event("show-more", %{"date" => date}, socket) do
    case Timex.parse(date, "{YYYY}-{0M}-{0D}") do
      {:ok, naive_date} ->
        date = Timex.to_date(naive_date)

        {:noreply,
         socket
         |> assign(:current_date, date)
         |> push_patch(to: Routes.calendar_show_path(socket, :show, mode: "week"), replace: true)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("set-current-date", %{"date" => date}, socket) do
    case Timex.parse(date, "{YYYY}-{0M}-{0D}") do
      {:ok, naive_date} ->
        date = Timex.to_date(naive_date)

        date =
          if date.month != socket.assigns.current_date.month && socket.assigns.mode == "month" do
            socket.assigns.current_date
          else
            date
          end

        {:noreply,
         socket
         |> assign(:current_date, date)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  defp assigns_dates(socket) do
    if socket.assigns.mode == "week" do
      assigns_week(socket, Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
    else
      assigns_month(socket, Routes.calendar_show_path(AtomicWeb.Endpoint, :show))
    end
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

  defp multi_day_activity?(activity) do
    Timex.diff(activity.finish, activity.start, :days) > 0
  end

  defp split_activity_by_day(activity) do
    start_date = Timex.to_date(activity.start)
    end_date = Timex.to_date(activity.finish)

    Enum.map(0..Timex.diff(end_date, start_date, :days), fn offset ->
      day_start =
        if offset > 0 do
          Timex.shift(activity.start, days: offset) |> Timex.beginning_of_day()
        else
          activity.start
        end

      day_end =
        if offset == Timex.diff(end_date, start_date, :days) do
          activity.finish
        else
          Timex.end_of_day(day_start)
        end

      %{activity | start: day_start, finish: day_end}
    end)
  end

  defp list_activities(timezone, mode, current_date, current_user) do
    if current_user do
      organizations_id =
        Organizations.list_organizations_followed_by_user(current_user.id)
        |> Enum.map(fn org -> org.id end)

      start = Timex.shift(build_beggining_date(timezone, mode, current_date), days: -7)
      finish = Timex.shift(build_ending_date(timezone, mode, current_date), days: 7)

      Activities.list_activities_from_to(start, finish)
      |> Enum.filter(fn activity -> activity.organization_id in organizations_id end)
      |> Enum.map(fn activity ->
        if multi_day_activity?(activity) do
          split_activity_by_day(activity)
        else
          [activity]
        end
      end)
      |> List.flatten()
    else
      []
    end
  end
end
