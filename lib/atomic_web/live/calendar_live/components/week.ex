defmodule AtomicWeb.CalendarLive.Components.CalendarWeek do
  @moduledoc false
  use AtomicWeb, :component

  alias Timex.Duration

  import AtomicWeb.CalendarLive.Components.CalendarUtils

  attr :id, :string, default: "calendar-week", required: false
  attr :current_date, :string, required: true
  attr :activities, :list, required: true
  attr :timezone, :string, required: true
  attr :beginning_of_week, :string, required: true
  attr :end_of_week, :string, required: true
  attr :params, :map, required: true

  def calendar_week(%{timezone: timezone} = assigns) do
    assigns =
      assigns
      |> assign(week_mobile: ["M", "T", "W", "T", "F", "S", "S"])
      |> assign(week: ["Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat ", "Sun "])
      |> assign(today: Timex.today(timezone))

    ~H"""
    <div id={@id} class="isolate flex flex-auto flex-col overflow-y-auto rounded-lg bg-white">
      <div style="width: 165%" class="flex max-w-full flex-none flex-col sm:max-w-none md:max-w-full">
        <div class="sticky top-0 z-30 flex-none bg-white shadow ring-1 ring-black ring-opacity-5 sm:pr-8">
          <div class="grid grid-cols-7 text-sm leading-6 text-zinc-500 sm:hidden">
            <%= for idx <- 0..6 do %>
              <% day_of_week = @beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
              <.link phx-click="set-current-date" phx-value-date={day_of_week} class="flex flex-col items-center py-2">
                <%= Enum.at(@week_mobile, idx) %>
                <span class={[
                  "flex items-center justify-center w-8 h-8 mt-1 font-semibold",
                  @today == day_of_week && "bg-primary-700 rounded-full text-white",
                  @today != day_of_week && day_of_week == @current_date && "bg-zinc-900 rounded-full text-white",
                  @today != day_of_week && day_of_week != @current_date && "text-zinc-900"
                ]}>
                  <%= day_of_week |> date_to_day() %>
                </span>
              </.link>
            <% end %>
          </div>
          <div class="-mr-px hidden grid-cols-7 divide-x divide-zinc-100 border-r border-zinc-100 text-sm leading-6 text-zinc-500 sm:grid">
            <div class="col-end-1 w-14"></div>
            <%= for idx <- 0..6 do %>
              <% day_of_week = @beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
              <div id={"day-of-week-#{idx}"} class="flex h-12 items-center justify-center">
                <span class={@today == day_of_week && "flex items-baseline"}>
                  <%= Enum.at(@week, idx) %>
                  <span class={[
                    "items-center justify-center font-semibold",
                    @today == day_of_week && "flex ml-1.5 w-8 h-8 text-white bg-primary-600 rounded-full",
                    @today != day_of_week && "text-zinc-900"
                  ]}>
                    <%= day_of_week |> date_to_day() %>
                  </span>
                </span>
              </div>
            <% end %>
          </div>
        </div>
        <div class="flex flex-auto">
          <div class="sticky left-0 z-20 w-14 flex-none bg-white ring-1 ring-zinc-100"></div>
          <div class="grid flex-auto grid-cols-1 grid-rows-1">
            <!-- Horizontal lines -->
            <div class="col-start-1 col-end-2 row-start-1 grid divide-y divide-zinc-100" style="grid-template-rows: repeat(48, minmax(3.5rem, 1fr))">
              <div class="row-end-1 h-7"></div>
              <%= for hour <- hours() do %>
                <div>
                  <div class="sticky left-0 z-20 -mt-2.5 -ml-14 w-14 pr-2 text-right text-xs leading-5 text-zinc-400"><%= hour %></div>
                </div>
                <div></div>
              <% end %>
            </div>
            <!-- Vertical lines -->
            <div class="col-start-1 col-end-2 row-start-1 hidden grid-cols-7 grid-rows-1 divide-x divide-zinc-100 sm:grid sm:grid-cols-7">
              <div class="col-start-1 row-span-full"></div>
              <div class="col-start-2 row-span-full"></div>
              <div class="col-start-3 row-span-full"></div>
              <div class="col-start-4 row-span-full"></div>
              <div class="col-start-5 row-span-full"></div>
              <div class="col-start-6 row-span-full"></div>
              <div class="col-start-7 row-span-full"></div>
              <div class="col-start-8 row-span-full w-8"></div>
            </div>
            <!-- Events -->
            <ol class="col-start-1 col-end-2 row-start-1 grid grid-cols-1 sm:hidden" style="grid-template-rows: 1.75rem repeat(288, minmax(0, 1fr))">
              <.day date={@current_date} idx={0} activities={@activities} />
            </ol>
            <ol class="col-start-1 col-end-2 row-start-1 hidden sm:grid sm:grid-cols-7 sm:pr-8" style="grid-template-rows: 1.75rem repeat(288, minmax(0, 1fr)) auto">
              <%= for idx <- 0..6 do %>
                <.day date={Timex.shift(@beginning_of_week, days: idx)} idx={idx} activities={@activities} />
              <% end %>
            </ol>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp day(assigns) do
    assigns =
      assigns
      |> assign_activities_positions(get_date_activities(assigns.activities, assigns.date))

    ~H"""
    <%= for {activity, width, left} <- @activities_with_positions do %>
      <li class={"#{col_start(@idx + 1)} relative mt-px flex"} style={"
            grid-row: #{calc_row_start(activity.start)} / span #{calc_time(activity.start, activity.finish)};
            width: #{width}%;
            left: #{left}%"}>
        <.link patch={Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity)}>
          <div class={[
            "group absolute inset-1 flex flex-col overflow-x-hidden rounded-md bg-primary-50 p-2 text-xs leading-5 hover:bg-primary-100 sm:overflow-y-hidden sm:hover:overflow-y-auto",
            width != 100 && "sm:hover:z-10 sm:hover:w-max sm:max-w-[117px]"
          ]}>
            <p class="text-primary-500 order-1 font-semibold">
              <%= activity.title %>
            </p>
            <p class="text-primary-500 group-hover:text-primary-800">
              <time datetime={activity.start}><%= Calendar.strftime(activity.start, "%Hh%M") %></time>
            </p>
          </div>
        </.link>
      </li>
    <% end %>
    """
  end

  defp assign_activities_positions(assigns, day_activities) do
    activities_with_positions =
      Enum.map(day_activities, fn activity ->
        # Calculate the width of the activity in percentage
        width = 1 / (calc_total_overlaps(activity, day_activities) + 1) * 100

        # Calculate the left position of the activity in percentage
        left =
          calc_left_amount(
            activity,
            day_activities,
            calc_total_overlaps(activity, day_activities) + 1
          )

        {activity, width, left}
      end)

    assign(assigns, :activities_with_positions, activities_with_positions)
  end

  defp calc_row_start(start) do
    hours =
      start
      |> Timex.format!("{h24}")
      |> String.to_integer()

    minutes =
      start
      |> Timex.format!("{m}")
      |> String.to_integer()

    hours * 12 + div(minutes, 5) + 2
  end

  # Each row spans a 5-minute interval.
  # Calculates the number of grid rows the activity should
  # span based on the time difference between the start and finish.
  #
  # Example
  #
  # iex> calc_time(~N[2024-09-11 09:00:00], ~N[2024-09-11 10:00:00])
  # 12

  defp calc_time(start, finish) do
    time_diff = (NaiveDateTime.diff(finish, start) / 60) |> trunc()

    if time_diff == 0 do
      1
    else
      div(time_diff, 5)
    end
  end

  # Calculates the total number of overlapping activities with the current activity on the same day.
  #
  # Example
  #
  # iex> activities = [
  # ...>   %{start: ~N[2024-09-11 09:00:00], finish: ~N[2024-09-11 10:00:00]},
  # ...>   %{start: ~N[2024-09-11 09:30:00], finish: ~N[2024-09-11 10:30:00]}
  # ...> ]
  # ...>
  # ...> calc_total_overlaps(
  # ...>   %{start: ~N[2024-09-11 09:00:00], finish: ~N[2024-09-11 10:00:00]},
  # ...>   activities
  # ...> )
  # 1

  def calc_total_overlaps(current_activity, activities) do
    current_interval =
      Timex.Interval.new(from: current_activity.start, until: current_activity.finish)

    activities
    |> Enum.filter(fn activity ->
      activity_interval = Timex.Interval.new(from: activity.start, until: activity.finish)

      activity != current_activity && activity.start.day == current_activity.start.day and
        Timex.Interval.overlaps?(current_interval, activity_interval)
    end)
    |> length()
  end

  # Calculates the left offset percentage for positioning an activity on the calendar grid.
  #
  # The left offset is determined by the number of overlapping activities prior to the current one.
  #
  #
  # Example
  #
  # iex> activities = [
  # ...>   %{start: ~N[2024-09-11 09:00:00], finish: ~N[2024-09-11 10:00:00]},
  # ...>   %{start: ~N[2024-09-11 09:30:00], finish: ~N[2024-09-11 10:30:00]}
  # ...> ]
  # ...>
  # ...> calc_left_amount(
  # ...>   %{start: ~N[2024-09-11 09:30:00], finish: ~N[2024-09-11 10:30:00]},
  # ...>   activities,
  # ...>   2
  # ...> )
  # 50.0
  defp calc_left_amount(current_activity, activities, activity_total_overlaps) do
    current_interval =
      Timex.Interval.new(from: current_activity.start, until: current_activity.finish)

    # Total number of overlaps prior to the current activity
    total_overlaps =
      activities
      |> Enum.take_while(fn activity -> activity != current_activity end)
      |> Enum.filter(fn activity ->
        activity_interval = Timex.Interval.new(from: activity.start, until: activity.finish)

        activity != current_activity && activity.start.day == current_activity.start.day and
          Timex.Interval.overlaps?(current_interval, activity_interval)
      end)
      |> length()

    if total_overlaps > 0 do
      total_overlaps / activity_total_overlaps * 100
    else
      0
    end
  end

  defp hours,
    do: [
      "0H",
      "1H",
      "2H",
      "3H",
      "4H",
      "5H",
      "6H",
      "7H",
      "8H",
      "9H",
      "10H",
      "11H",
      "12H",
      "13H",
      "14H",
      "15H",
      "16H",
      "17H",
      "18H",
      "19H",
      "20H",
      "21H",
      "22H",
      "23H"
    ]
end
