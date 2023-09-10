defmodule AtomicWeb.Components.CalendarWeek do
  @moduledoc false
  use AtomicWeb, :component

  alias Timex.Duration

  import AtomicWeb.CalendarUtils

  def calendar_week(%{timezone: timezone} = assigns) do
    assigns =
      assigns
      |> assign(week_mobile: ["M", "T", "W", "T", "F", "S", "S"])
      |> assign(week: ["Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat ", "Sun "])
      |> assign(today: Timex.today(timezone))

    ~H"""
    <div class="flex flex-auto flex-col overflow-auto rounded-lg bg-white">
      <div style="width: 165%" class="flex max-w-full flex-none flex-col sm:max-w-none md:max-w-full">
        <div class="sticky top-0 z-10 flex-none bg-white shadow ring-1 ring-black ring-opacity-5">
          <div class="grid grid-cols-7 text-sm leading-6 text-zinc-500 sm:hidden">
            <%= for idx <- 0..6 do %>
              <% day_of_week = @beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
              <%= live_patch to: build_path(@current_path, %{"mode" => "week", "day" => day_of_week |> date_to_day(), "month" => @params["month"], "year" => @params["year"]}), class: "flex flex-col items-center py-2" do %>
                <%= Enum.at(@week_mobile, idx) %>
                <span class={
                  "#{if @today == day_of_week do
                    "bg-orange-700 rounded-full text-white"
                  else
                    if day_of_week |> date_to_day() == @params["day"] do
                      "bg-zinc-900 rounded-full text-white"
                    else
                      "text-zinc-900"
                    end
                  end} flex items-center justify-center w-8 h-8 mt-1 font-semibold"
                }>
                  <%= day_of_week |> date_to_day() %>
                </span>
              <% end %>
            <% end %>
          </div>
          <div class="-mr-px hidden grid-cols-7 divide-x divide-zinc-100 border-r border-zinc-100 text-sm leading-6 text-zinc-500 sm:grid">
            <div class="col-end-1 w-12"></div>
            <%= for idx <- 0..6 do %>
              <% day_of_week = @beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
              <div id={"day-of-week-#{idx}"} class="flex h-12 items-center justify-center">
                <span class={
                  if @today == day_of_week do
                    "flex items-baseline"
                  else
                    ""
                  end
                }>
                  <%= Enum.at(@week, idx) %>
                  <span class={
                    "#{if @today == day_of_week do
                      "flex ml-1.5 w-8 h-8 text-white bg-orange-700 rounded-full"
                    else
                      "text-zinc-900"
                    end} items-center justify-center font-semibold"
                  }>
                    <%= day_of_week |> date_to_day() %>
                  </span>
                </span>
              </div>
            <% end %>
          </div>
        </div>
        <div class="flex flex-auto">
          <div class="left-0 w-12 flex-none bg-white ring-1 ring-zinc-100"></div>
          <div class="grid flex-auto grid-cols-1 grid-rows-1">
            <!-- Horizontal lines -->
            <div class="col-start-1 col-end-2 row-start-1 grid divide-y divide-zinc-100" style="grid-template-rows: repeat(30, minmax(2.5rem, 1fr))">
              <div class="row-end-1 h-6"></div>
              <%= for hour <- hours() do %>
                <div>
                  <div class="left-0 -mt-2.5 -ml-14 w-12 pr-2 text-right text-xs leading-5 text-zinc-400"><%= hour %></div>
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
            </div>
            <!-- Events -->
            <ol class="col-start-1 col-end-2 row-start-1 grid grid-cols-1 sm:hidden" style="grid-template-rows: 1.25rem repeat(301, minmax(0, 1fr))">
              <.day date={@current} idx={0} activities={@activities} />
            </ol>
            <ol class="col-start-1 col-end-2 row-start-1 hidden sm:grid sm:grid-cols-7" style="grid-template-rows: 1.25rem repeat(301, minmax(0, 1fr))">
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
    ~H"""
    <%= for activity <- get_date_activities(@activities, @date) do %>
      <%= if activity do %>
        <li class={"#{col_start(@idx + 1)} relative mt-px flex"} style={"grid-row: #{calc_row_start(activity.start)} / span #{calc_time(activity.start, activity.finish)}"}>
          <%= live_patch to: Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity, assigns.organization) do %>
            <div class="group absolute inset-1 flex flex-col overflow-y-auto rounded-lg bg-orange-50 p-2 text-xs leading-5 hover:bg-orange-100">
              <p class="order-1 font-semibold text-orange-500">
                activity.title
              </p>
              <p class="text-orange-500 group-hover:text-orange-800">
                <time datetime={activity.start}><%= Calendar.strftime(activity.start, "%Hh%M") %></time>
              </p>
            </div>
          <% end %>
        </li>
      <% end %>
    <% end %>
    """
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

    minutes = (minutes * 20 / 60) |> trunc()

    2 + (hours - 8) * 20 + minutes
  end

  defp calc_time(start, finish) do
    time_diff = (NaiveDateTime.diff(finish, start) / 3600) |> trunc()

    2 + 20 * time_diff
  end

  defp hours,
    do: [
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
      "22H"
    ]
end
