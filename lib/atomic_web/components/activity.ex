defmodule AtomicWeb.Components.Activity do
  @moduledoc """
  Renders an activity.

  These are the variants:

    * `default` - activity with a title and description
  """
  use AtomicWeb, :component

  def default(assigns) do
    ~H"""
    <!-- Main content -->
    <div>
      <div class="flex space-x-3">
        <div class="flex-shrink-0">
          <%= if @activity.organization.logo do %>
            <div class="flex-shrink-0">
              <img class="h-10 w-10 object-center" src={Uploaders.Logo.url({@activity.organization.logo, @activity.organization}, :original)} />
            </div>
          <% else %>
            <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-zinc-200 md:h-10 md:w-10">
              <span class="text-xs font-medium leading-none text-zinc-600">
                <%= extract_initials(@activity.organization.name) %>
              </span>
            </span>
          <% end %>
        </div>
        <div class="min-w-0 flex-1">
          <p class="text-sm font-bold text-gray-900">
            <%= @activity.organization.name %>
          </p>
          <p class="text-sm text-gray-500">
            <span class="sr-only">Published on</span>
            <time><%= relative_datetime(@activity.inserted_at) %></time>
          </p>
        </div>
      </div>
      <h2 class="mt-3 text-base font-semibold text-gray-900"><%= @activity.title %></h2>
    </div>
    <div class="text-justify text-sm text-gray-700">
      <p><%= @activity.description %></p>
    </div>
    <!-- Image -->
    <%= if @activity.image do %>
      <div class="mt-4">
        <img class="max-w-xs rounded-md lg:max-w-md" src={@url} />
      </div>
    <% end %>
    <!-- Footer -->
    <div class="mt-3 flex flex-row justify-between">
      <div class="flex space-x-4">
        <span class="inline-flex items-center text-sm">
          <span class="inline-flex space-x-2 text-zinc-400">
            <Heroicons.Solid.clock class="h-5 w-5" />
            <span class="font-medium text-gray-900"><%= relative_datetime(@activity.start) %></span>
            <span class="sr-only">starting in</span>
          </span>
        </span>
        <span class="inline-flex items-center text-sm">
          <span class="inline-flex space-x-2 text-zinc-400">
            <Heroicons.Solid.user_group class="h-5 w-5" />
            <span class="font-medium text-gray-900"><%= @activity.enrolled %>/<%= @activity.maximum_entries %></span>
            <span class="sr-only">enrollments</span>
          </span>
        </span>
        <span class="inline-flex items-center text-sm">
          <span class="inline-flex space-x-2 text-zinc-400">
            <Heroicons.Solid.location_marker class="h-5 w-5" />
            <span class="font-medium text-gray-900"><%= @activity.location.name %></span>
            <span class="sr-only">location</span>
          </span>
        </span>
      </div>
      <%= live_redirect("View this activity", to: Routes.activity_show_path(AtomicWeb.Endpoint, :show, @activity), class: "text-md w-auto cursor-pointer text-orange-500 hover:underline") %>
    </div>
    """
  end
end
