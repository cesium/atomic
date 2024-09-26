defmodule AtomicWeb.HomeLive.Components.Schedule do
  @moduledoc false
  use AtomicWeb, :component

  attr :schedule, :map, required: true, doc: "The schedule to display."

  def schedule(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <div :if={length(@schedule.daily) != 0} class="px-4 pt-6 sm:px-0">
        <p class="text-xl font-semibold text-gray-900">
          Today
        </p>
        <div class="flow-root">
          <ul role="list" class="divide-y divide-gray-200">
            <%= for entry <- @schedule.daily do %>
              <.link navigate={~p"/activities/#{entry}"}>
                <li class="space-y-3 py-4">
                  <p class="text-md font-semibold hover:underline">
                    <%= entry.title %>
                  </p>
                  <div class="w-[110px] flex h-6 items-center justify-center space-x-1 rounded-md bg-orange-100 text-orange-500 opacity-70">
                    <.icon name="hero-clock-solid" class="size-4" />
                    <p class="text-xs font-semibold">
                      <%= display_time(entry.start) %> - <%= display_time(entry.finish) %>
                    </p>
                  </div>
                  <p class="text-justify text-sm text-gray-700">
                    <%= entry.description %>
                  </p>
                </li>
              </.link>
            <% end %>
          </ul>
        </div>
      </div>
      <div :if={length(@schedule.weekly) != 0} class={"#{if length(@schedule.daily) != 0, do: 'pt-3', else: 'pt-6'} px-4 sm:px-0"}>
        <p class="text-xl font-semibold text-gray-900">
          This week
        </p>
        <div class="flow-root">
          <ul role="list" class="divide-y divide-gray-200">
            <%= for entry <- @schedule.weekly do %>
              <.link navigate={~p"/activities/#{entry}"}>
                <li class="space-y-3 py-4">
                  <p class="text-md font-semibold hover:underline">
                    <%= entry.title %>
                  </p>
                  <div class="w-[110px] flex h-6 items-center justify-center space-x-1 rounded-md bg-orange-100 text-orange-500 opacity-70">
                    <.icon name="hero-clock-solid" class="size-4" />
                    <p class="text-xs font-semibold">
                      <%= pretty_display_date(entry.start) %>
                    </p>
                  </div>
                  <p class="text-justify text-sm text-gray-700">
                    <%= entry.description %>
                  </p>
                </li>
              </.link>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
