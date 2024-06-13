defmodule AtomicWeb.ActivityLive.Components.ActivityCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Gradient}

  attr :activity, :map, required: true, doc: "The activity to display."

  def activity_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <!-- TODO: Add almost full! Indicator -->
      <.link navigate={Routes.activity_show_path(AtomicWeb.Endpoint, :show, @activity)}>
        <div class="grid grid-cols-3">
          <!-- Activity information -->
          <div class="col-span-2 px-4 py-4 lg:px-6">
            <div class="flex items-center justify-between">
              <p class="text-md truncate font-medium text-zinc-900">
                <%= @activity.title %>
              </p>
            </div>
            <div class="mt-2 lg:flex lg:justify-between">
              <div class="lg:flex lg:space-x-3">
                <p class="mt-2 flex items-center text-sm text-zinc-500 lg:mt-0">
                  <.icon name={:calendar} solid class="mr-1.5 h-5 w-5 flex-shrink-0 text-zinc-400" />
                  <%= if @activity.start do %>
                    <%= pretty_display_date(@activity.start) %>
                  <% end %>
                </p>
                <%= if @activity.location do %>
                  <p class="mt-2 flex items-center text-sm text-zinc-500 lg:mt-0">
                    <.icon name={:map_pin} solid class="mr-1.5 h-5 w-5 flex-shrink-0 text-zinc-400" />
                    <%= @activity.location && @activity.location.name %>
                  </p>
                <% end %>
              </div>
            </div>
            <object>
              <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @activity.organization.id)} class="group flex max-w-min pt-2">
                <.icon name={:building_office} solid class="mr-1.5 h-5 w-5 text-zinc-400" />
                <span class="text-sm text-zinc-500 focus:outline-none group-hover:underline">
                  <%= @activity.organization.name %>
                </span>
              </.link>
            </object>
            <div class="flex lg:items-center lg:justify-between">
              <div class="flex flex-row space-x-2">
                <%= for speaker <- @activity.speakers do %>
                  <div class="mt-2 flex items-center">
                    <.avatar name={speaker.name} size={:xs} color={:light_gray} class="!w-6 !h-6 mr-1.5" />
                    <p class="text-sm text-zinc-500">
                      <%= extract_first_last_name(speaker.name) %>
                    </p>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
          <!-- Activity image -->
          <div class="h-48 object-cover">
            <%= if @activity.image do %>
              <img class="h-full w-full rounded-r-lg object-cover" src={Uploaders.Post.url({@activity.image, @activity}, :original)} />
            <% else %>
              <.gradient seed={@activity.id} class="rounded-r-lg" />
            <% end %>
          </div>
        </div>
      </.link>
    </div>
    """
  end
end
