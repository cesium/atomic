defmodule AtomicWeb.Components.CalendarMonth do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.Badges

  def calendar_month(assigns) do
    ~H"""
    <div class="rounded-lg shadow ring-1 ring-black ring-opacity-5 lg:flex lg:flex-auto lg:flex-col">
      <div class="grid grid-cols-7 gap-px rounded-t-lg border-b border-zinc-300 bg-zinc-200 text-center text-xs font-semibold leading-6 text-zinc-700 lg:flex-none">
        <div class="rounded-tl-lg bg-white py-2">
          M<span class="sr-only sm:not-sr-only">on</span>
        </div>
        <div class="bg-white py-2">
          T<span class="sr-only sm:not-sr-only">ue</span>
        </div>
        <div class="bg-white py-2">
          W<span class="sr-only sm:not-sr-only">ed</span>
        </div>
        <div class="bg-white py-2">
          T<span class="sr-only sm:not-sr-only">hu</span>
        </div>
        <div class="bg-white py-2">
          F<span class="sr-only sm:not-sr-only">ri</span>
        </div>
        <div class="bg-white py-2">
          S<span class="sr-only sm:not-sr-only">at</span>
        </div>
        <div class="rounded-tr-lg bg-white py-2">
          S<span class="sr-only sm:not-sr-only">un</span>
        </div>
      </div>
      <div class="flex bg-zinc-200 text-xs leading-6 text-zinc-700 lg:flex-auto">
        <div class="grid w-full grid-cols-7 gap-px overflow-hidden rounded-b-lg">
          <%= for i <- 0..@end_of_month.day - 1 do %>
            <.day index={i} params={@params} current_path={@current_path} activities={@activities} date={Timex.shift(@beginning_of_month, days: i)} timezone={@timezone} />
          <% end %>
        </div>
      </div>
    </div>
    <div class="py-4 lg:hidden">
      <ol class="divide-y divide-zinc-200 overflow-hidden rounded-lg bg-white text-sm shadow ring-1 ring-black ring-opacity-5">
        <%= for activity <- get_date_activities(@activities, current_from_params(@timezone, @params)) do %>
          <%= live_patch to: Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity) do %>
            <li class="group flex p-4 pr-6 focus-within:bg-zinc-50 hover:bg-zinc-50">
              <div class="flex-auto">
                <p class="font-semibold text-zinc-900">
                  <%= activity.title %>
                </p>
                <div class="flex flex-row items-center gap-x-2 pt-2">
                  <.badge_dot url={Routes.activity_index_path(AtomicWeb.Endpoint, :index)} color="purple">
                    Activity
                  </.badge_dot>
                  <time datetime={activity.start} class="flex items-center text-zinc-700">
                    <Heroicons.Solid.clock class="mr-2 h-5 w-5 text-zinc-400" />
                    <%= Calendar.strftime(activity.start, "%Hh%M") %>
                  </time>
                </div>
              </div>
            </li>
          <% end %>
        <% end %>
      </ol>
    </div>
    """
  end

  defp day(%{index: index, date: date, timezone: timezone} = assigns) do
    weekday = Timex.weekday(date, :monday)
    today? = Timex.compare(date, Timex.today(timezone))

    class =
      class_list([
        {"relative py-2 px-3 lg:min-h-[110px] lg:flex hidden", true},
        {col_start(weekday), index == 0},
        {"bg-white", today? >= 0},
        {"bg-zinc-50 text-zinc-500", today? < 0}
      ])

    assigns =
      assigns
      |> assign(disabled: today? < 0)
      |> assign(:text, Timex.format!(date, "{D}"))
      |> assign(:class, class)
      |> assign(:date, date)
      |> assign(:today?, today?)

    ~H"""
    <div class={@class}>
      <time
        date-time={@date}
        class={
          "ml-auto lg:ml-0 pr-2 lg:pr-0 #{if today? == 0 do
            "flex h-6 w-6 items-center justify-center rounded-full bg-orange-600 font-semibold text-white shrink-0"
          end}"
        }
      >
        <%= @text %>
      </time>
      <ol class="mt-3 w-full">
        <%= for activity <- get_date_activities(@activities, @date) do %>
          <li>
            <%= live_patch to: Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity), class: "group flex" do %>
              <p class="flex-auto truncate font-medium text-zinc-600 group-hover:text-zinc-800">
                <%= activity.title %>
              </p>
              <time datetime={activity.start} class="mx-2 hidden flex-none text-zinc-600 group-hover:text-zinc-800 xl:block"><%= Calendar.strftime(activity.start, "%Hh") %></time>
            <% end %>
          </li>
        <% end %>
      </ol>
    </div>
    <%= live_patch to: build_path(@current_path, %{mode: "month", day: date_to_day(@date), month: date_to_month(@date), year: date_to_year(@date)}), class: "#{if @index == 0 do col_start(weekday) end} min-h-[56px] flex w-full flex-col bg-white px-3 py-2 text-zinc-900 hover:bg-zinc-100 focus:z-10 lg:hidden" do %>
      <time
        date-time={@date}
        class={
          "ml-auto lg:ml-0 #{if current_from_params(@timezone, @params) == @date do
            "ml-auto flex h-6 w-6 items-center justify-center rounded-full #{if today? == 0 do
              "bg-orange-700"
            else
              "bg-zinc-900"
            end} text-white shirk-0"
          else
            if today? == 0 do
              "text-orange-700"
            end
          end}"
        }
      >
        <%= @text %>
      </time>
      <%= if (activities = get_date_activities(@activities, @date)) != [] do %>
        <span class="sr-only">Enum.count(activities) events</span>
        <span class="-mx-0.5 mt-auto flex flex-wrap-reverse">
          <%= for activity <- activities do %>
            <%= if activity do %>
              <span class="mx-0.5 mb-1 h-1.5 w-1.5 rounded-full bg-zinc-700"></span>
            <% end %>
          <% end %>
        </span>
      <% end %>
    <% end %>
    """
  end
end
