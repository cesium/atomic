defmodule AtomicWeb.HomeLive.Components.Schedule do
  @moduledoc false
  use AtomicWeb, :component

  attr :schedule, :map, required: true, doc: "The schedule to display."

  def schedule(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <div :if={length(@schedule.daily) != 0} class="px-4 pt-4 pb-2 border-b border-gray-200 sm:px-0">
        <p class="font-semibold text-zinc-400">
          Today
        </p>
        <div class="flow-root">
          <ul role="list">
            <%= for entry <- @schedule.daily do %>
              <.link navigate={Routes.activity_show_path(AtomicWeb.Endpoint, :show, entry)}>
                <li class="space-y-3 pt-4">
                  <div class="flex justify-between">
                    <p class="text-md font-semibold hover:underline">
                      <%= entry.title %>
                    </p>
                    <div class="w-[110px] flex h-6 items-center justify-center space-x-1 rounded-md bg-orange-100 text-orange-500 opacity-70">
                      <.icon name="hero-clock-solid" class="size-4" />
                      <p class="text-xs font-semibold">
                        <%= display_time(entry.start) %> - <%= display_time(entry.finish) %>
                      </p>
                    </div>
                  </div>
                  <p class="text-justify text-sm text-gray-700">
                    <%= maybe_slice_string(entry.description, 100) %>
                  </p>
                </li>
              </.link>
              <div class="text-zinc-400 text-right">
                <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, entry.organization.id)} class="text-xs hover:underline">
                  <%= entry.organization.name %>
                </.link>
              </div>
            <% end %>
          </ul>
        </div>
      </div>
      <div :if={length(@schedule.weekly) != 0} class={"#{if length(@schedule.daily) != 0, do: 'pt-2', else: 'pt-4'} pb-2 px-4 sm:px-0"}>
        <p class="font-semibold text-zinc-400">
          This week
        </p>
        <div class="flow-root">
          <ul role="list">
            <%= for entry <- @schedule.weekly do %>
              <.link navigate={Routes.activity_show_path(AtomicWeb.Endpoint, :show, entry)}>
                <li class="space-y-3 pt-4">
                  <div class="flex justify-between">
                    <p class="text-md font-semibold hover:underline">
                      <%= entry.title %>
                    </p>
                    <div class="w-[110px] flex h-6 items-center justify-center space-x-1 rounded-md bg-orange-100 text-orange-500 opacity-70">
                      <.icon name="hero-calendar-solid" class="size-4" />
                      <p class="text-xs font-semibold">
                        <%= pretty_display_date(entry.start) %>
                      </p>
                    </div>
                  </div>
                  <p class="text-justify text-sm text-gray-700">
                    <%= maybe_slice_string(entry.description, 150) %>
                  </p>
                </li>
              </.link>
              <div class="text-zinc-400 text-right">
                <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, entry.organization.id)} class="text-xs hover:underline">
                  <%= entry.organization.name %>
                </.link>
              </div>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
