defmodule AtomicWeb.Components.CalendarMonth do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.Badge

  attr :id, :string, default: "calendar-month", required: false
  attr :current_date, :string, required: true
  attr :activities, :list, required: true
  attr :timezone, :string, required: true
  attr :beginning_of_month, :string, required: true
  attr :end_of_month, :string, required: true
  attr :params, :map, required: true

  def calendar_month(assigns) do
    ~H"""
    <div id={@id} class="shadow lg:flex lg:flex-auto lg:flex-col">
      <div class="grid grid-cols-7 gap-px border-b border-zinc-300 bg-zinc-200 text-center text-xs font-semibold leading-6 text-zinc-700 lg:flex-none">
        <div class="bg-white py-2">
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
        <div class="bg-white py-2">
          S<span class="sr-only sm:not-sr-only">un</span>
        </div>
      </div>
      <div class="flex bg-zinc-200 text-xs leading-6 text-zinc-700 lg:flex-auto">
        <div class="grid w-full grid-cols-7 grid-rows-6 gap-px overflow-hidden">
          <%= for date <- generate_days_list(@beginning_of_month, @end_of_month) do %>
            <%!-- <p><%= @end_of_month %></p> --%>
            <.day params={@params} date={date} current_date={@current_date} activities={@activities} timezone={@timezone} />
          <% end %>
        </div>
      </div>
    </div>
    <div class="py-4 lg:hidden">
      <ol class="divide-y divide-zinc-200 overflow-hidden rounded-lg bg-white text-sm shadow">
        <%= for activity <- get_date_activities(@activities, current_from_params(@timezone, @params)) do %>
          <.link patch={Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity)}>
            <li class="group flex p-4 pr-6 focus-within:bg-zinc-50 hover:bg-zinc-50">
              <div class="flex-auto">
                <p class="font-semibold text-zinc-900">
                  <%= activity.title %>
                </p>
                <div class="flex flex-row items-center gap-x-2 pt-2">
                  <.link navigate={Routes.activity_index_path(AtomicWeb.Endpoint, :index)}>
                    <.badge variant={:outline} color={:primary} label="Activity" />
                  </.link>
                  <time datetime={activity.start} class="flex items-center text-zinc-700">
                    <.icon name={:clock} solid class="mr-2 h-5 w-5 text-zinc-400" />
                    <%= Calendar.strftime(activity.start, "%Hh%M") %>
                  </time>
                </div>
              </div>
            </li>
          </.link>
        <% end %>
      </ol>
    </div>
    """
  end

  defp generate_days_list(beginning_of_month, end_of_month) do
    days_from_last_month = Timex.weekday(beginning_of_month, :monday)

    past_month =
      for i <- 1..(days_from_last_month - 1) do
        Timex.shift(Timex.shift(beginning_of_month, days: -days_from_last_month), days: i)
      end

    current_month =
      for i <- 0..(end_of_month.day - 1) do
        Timex.shift(beginning_of_month, days: i)
      end

    next_month =
      for i <- 1..(42 - Timex.days_in_month(beginning_of_month) - days_from_last_month + 1) do
        Timex.shift(end_of_month, days: i)
      end

    if days_from_last_month == 1 do
      current_month ++ next_month
    else
      past_month ++ current_month ++ next_month
    end
  end

  defp day(%{date: date, timezone: timezone} = assigns) do
    weekday = Timex.weekday(date, :monday)
    today? = Timex.compare(date, Timex.today(timezone))

    class =
      class_list([
        {"relative py-2 px-3 lg:h-28 lg:flex flex-col hidden", true},
        {"bg-white", assigns.current_date.month == date.month},
        {"bg-zinc-50 text-zinc-500", assigns.current_date.month != date.month}
      ])

    assigns =
      assigns
      |> assign(disabled: today? < 0)
      |> assign(:text, Timex.format!(date, "{D}"))
      |> assign(:class, class)
      |> assign(:date, date)
      |> assign(:today?, today?)
      |> assign(:weekday, weekday)

    ~H"""
    <div class={@class}>
      <time date-time={@date} class={
          "ml-auto lg:ml-0 pr-2 lg:pr-0 #{if @today? == 0 do
            "flex h-6 w-6 items-center justify-center rounded-full bg-primary-600 font-semibold text-white"
          end}"
        }>
        <%= @text %>
      </time>
      <ol class="mt-2 -space-y-1">
        <%= for activity <- get_date_activities(@activities, @date) |> Enum.take(2) do %>
          <li>
            <.link patch={Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity)} class="group flex">
              <p class="flex-auto truncate font-medium text-zinc-900 group-hover:text-primary-600">
                <%= activity.title %>
              </p>
              <time datetime={activity.start} class="ml-3 hidden flex-none text-zinc-500 group-hover:text-primary-600 xl:block"><%= Calendar.strftime(activity.start, "%Hh") %></time>
            </.link>
          </li>
        <% end %>
        <%= if Enum.count(get_date_activities(@activities, @date)) > 2 do %>
          <li class="text-zinc-500 hover:text-primary-600">
            <button type="button" phx-click="show-more" phx-value-date={@date}>
              +<%= Enum.count(get_date_activities(@activities, @date)) - 2 %> more
            </button>
          </li>
        <% end %>
      </ol>
    </div>
    <.link patch={build_path("", %{mode: "month", day: date_to_day(@date), month: date_to_month(@date), year: date_to_year(@date)})} class="min-h-[56px] flex w-full flex-col bg-white px-3 py-2 text-zinc-900 hover:bg-zinc-100 focus:z-10 lg:hidden">
      <time
        date-time={@date}
        class={
          "ml-auto lg:ml-0 #{if current_from_params(@timezone, @params) == @date do
            "ml-auto flex h-6 w-6 items-center justify-center rounded-full #{if @today? == 0 do
              "bg-orange-700"
            else
              "bg-zinc-900"
            end} text-white shirk-0"
          else
            if @today? == 0 do
              "text-orange-700"
            end
          end}"
        }
      >
        <%= @text %>
      </time>
      <%= if (activities = get_date_activities(@activities, @date)) != [] do %>
        <span class="sr-only"><%= Enum.count(activities) %> events</span>
        <span class="-mx-0.5 mt-auto flex flex-wrap-reverse">
          <%= for activity <- activities do %>
            <%= if activity do %>
              <span class="mx-0.5 mb-1 h-1.5 w-1.5 rounded-full bg-zinc-700"></span>
            <% end %>
          <% end %>
        </span>
      <% end %>
    </.link>
    """
  end
end
