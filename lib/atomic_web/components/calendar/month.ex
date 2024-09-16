defmodule AtomicWeb.Components.CalendarMonth do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.CalendarUtils

  attr :id, :string, default: "calendar-month", required: false
  attr :current_date, :string, required: true
  attr :activities, :list, required: true
  attr :timezone, :string, required: true
  attr :beginning_of_month, :string, required: true
  attr :end_of_month, :string, required: true
  attr :params, :map, required: true

  def calendar_month(assigns) do
    ~H"""
    <div id={@id} class="shadow ring-1 ring-black ring-opacity-5 lg:flex lg:flex-auto lg:flex-col">
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
            <.day params={@params} date={date} current_date={@current_date} activities={@activities} timezone={@timezone} />
          <% end %>
        </div>
      </div>
    </div>
    <%= if length(get_date_activities(@activities, @current_date)) > 0 do %>
      <div class="px-4 py-10 sm:px-6 lg:hidden">
        <ol class="divide-y divide-zinc-100 overflow-hidden rounded-lg bg-white text-sm shadow ring-1 ring-black ring-opacity-5">
          <%= for activity <- get_date_activities(@activities, @current_date) do %>
            <li>
              <.link patch={Routes.activity_show_path(AtomicWeb.Endpoint, :show, activity)} class="group flex justify-between p-4 pr-6 focus-within:bg-gray-50 hover:bg-gray-50">
                <div class="flex-auto">
                  <p class="font-semibold text-zinc-900">
                    <%= activity.title %>
                  </p>
                  <div class="flex flex-row items-center gap-x-2 pt-2">
                    <time datetime={activity.start} class="mt-2 flex items-center text-zinc-700">
                      <.icon name="hero-clock-solid" class="size-5 mr-2 text-zinc-400" />
                      <%= Calendar.strftime(activity.start, "%Hh%M") %>
                    </time>
                  </div>
                </div>
              </.link>
            </li>
          <% end %>
        </ol>
      </div>
    <% end %>
    """
  end

  # Generates a list of days for the calendar month,
  # including days from the previous and next months to fill the 6x7 grid.
  #
  # Example
  #
  # iex> generate_days_list(~D[2024-09-01], ~D[2024-09-30])
  # [
  # ~D[2024-08-26],
  # ~D[2024-08-27],
  # ~D[2024-08-28],
  # ~D[2024-08-29],
  # ~D[2024-08-30],
  # ~D[2024-08-31],
  # ~D[2024-09-01],
  # ~D[2024-09-02],
  # ...,
  # ~D[2024-09-29],
  # ~D[2024-09-30],
  # ~D[2024-10-01],
  # ~D[2024-10-02],
  # ~D[2024-10-03],
  # ~D[2024-10-04],
  # ~D[2024-10-05],
  # ~D[2024-10-06]
  # ]

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
    today? = Timex.compare(date, Timex.today(timezone))

    assigns =
      assigns
      |> assign(:text, Timex.format!(date, "{D}"))
      |> assign(:date, date)
      |> assign(:today?, today?)

    ~H"""
    <div class={[
      "relative py-2 px-3 lg:h-28 lg:flex flex-col hidden",
      @current_date.month == @date.month && "bg-white",
      @current_date.month != @date.month && "bg-zinc-50 text-zinc-500"
    ]}>
      <time date-time={@date} class={
          "ml-auto lg:ml-0 pr-2 lg:pr-0 #{if @today? == 0 do
            "flex size-6 items-center justify-center rounded-full bg-primary-600 font-semibold text-white"
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
    <.link
      phx-click="set-current-date"
      phx-value-date={@date}
      class={[
        "min-h-[56px] flex w-full flex-col bg-white px-3 py-2 text-zinc-900 focus:z-10 lg:hidden",
        @current_date.month == @date.month && "hover:bg-zinc-100",
        @current_date.month != @date.month && "bg-zinc-50"
      ]}
    >
      <time
        date-time={@date}
        class={[
          "ml-auto lg:ml-0",
          @current_date == @date && "flex size-6 items-center justify-center rounded-full text-white shrink-0",
          @current_date == @date && @today? == 0 && "bg-primary-600",
          @current_date == @date && @today? != 0 && "bg-zinc-900",
          @current_date != @date && @today? == 0 && "text-primary-700",
          @current_date != @date && @date.month != @current_date.month && "text-zinc-500"
        ]}
      >
        <%= @text %>
      </time>
      <%= if (activities = get_date_activities(@activities, @date)) != [] do %>
        <span class="sr-only"><%= Enum.count(activities) %> events</span>
        <span class="-mx-0.5 mt-auto flex flex-wrap-reverse">
          <%= for activity <- Enum.take(activities, 3) do %>
            <%= if activity do %>
              <span class="mx-0.5 mb-1 h-1.5 w-1.5 rounded-full bg-zinc-400"></span>
            <% end %>
          <% end %>
        </span>
      <% end %>
    </.link>
    """
  end
end
