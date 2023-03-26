defmodule AtomicWeb.Components.CalendarWeek do
  @moduledoc false
  use AtomicWeb, :component

  alias Timex.Duration

  import AtomicWeb.CalendarUtils

  def calendar_week(
        %{
          beginning_of_week: beginning_of_week,
          time_zone: time_zone
        } = assigns
      ) do
    today = Timex.today(time_zone)

    assigns =
      assigns
      |> assign(week_mobile: ["M", "T", "W", "T", "F", "S", "S"])
      |> assign(week: ["Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat ", "Sun "])
      |> assign(beginning_of_week: beginning_of_week)
      |> assign(today: today)

    ~H"""
    <div class="flex flex-auto flex-col overflow-auto rounded-lg bg-white">
      <div style="width: 165%" class="flex max-w-full flex-none flex-col sm:max-w-none md:max-w-full">
        <div class="sticky top-0 z-10 flex-none bg-white shadow ring-1 ring-black ring-opacity-5">
          <div class="grid grid-cols-7 text-sm leading-6 text-zinc-500 sm:hidden">
            <%= for idx <- 0..6 do %>
              <% day_of_week = beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
              <%= live_patch to: build_path(@current_path, %{"mode" => "week", "day" => day_of_week |> date_to_day(), "month" => @params["month"], "year" => @params["year"]}), class: "flex flex-col items-center py-2" do %>
                <%= Enum.at(@week_mobile, idx) %>
                <span class={
                  "#{if @today == day_of_week do
                    "bg-indigo-700 rounded-full text-white"
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
              <% day_of_week = beginning_of_week |> Timex.add(Duration.from_days(idx)) %>
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
                      "flex ml-1.5 w-8 h-8 text-white bg-indigo-700 rounded-full"
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
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">8H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">9H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">10H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">11H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">12H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">13H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">14H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">15H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">16H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">17H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">18H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">19H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">20H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">21H</div>
              </div>
              <div></div>
              <div>
                <div class="left-0 pr-2 -mt-2.5 -ml-14 w-12 text-xs leading-5 text-right text-zinc-400">22H</div>
              </div>
              <div></div>
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
              <.day date={@current} idx={0} sessions={@sessions} />
            </ol>
            <ol class="col-start-1 col-end-2 row-start-1 hidden sm:grid sm:grid-cols-7" style="grid-template-rows: 1.25rem repeat(301, minmax(0, 1fr))">
              <%= for idx <- 0..6 do %>
                <.day date={Timex.shift(@beginning_of_week, days: idx)} idx={idx} sessions={@sessions} />
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
    <%= for session <- get_date_sessions(@sessions, @date) do %>
      <%= if session.activity do %>
        <li class={"#{col_start(@idx + 1)} relative mt-px flex"} style={"grid-row: #{calc_row_start(session.start)} / span #{calc_time(session.start, session.finish)}"}>
          <%= live_patch to: Routes.activity_show_path(AtomicWeb.Endpoint, :show, session.activity) do %>
            <div class="bg-indigo-50 hover:bg-indigo-100 group absolute inset-1 flex flex-col overflow-y-auto rounded-lg p-2 text-xs leading-5">
              <p class="text-indigo-600 order-1 font-semibold">
                session.activity.title
                <%!-- <%= if Gettext.get_locale() == "en" do
                  if session.activity.title_en do
                    session.activity.title_en
                  else
                    ""
                  end
                else
                  if session.activity.title_pt do
                    session.activity.title_pt
                  else
                    ""
                  end
                end %> --%>
              </p>
              <p class="text-indigo-600 group-hover:text-indigo-800">
                <time datetime={session.start}><%= Calendar.strftime(session.start, "%Hh%M") %></time>
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
end
