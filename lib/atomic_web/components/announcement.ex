defmodule AtomicWeb.Components.Announcement do
  @moduledoc """
  Renders an announcement with a title and description.
  """
  use AtomicWeb, :component

  def default(assigns) do
    ~H"""
    <div>
      <div class="flex space-x-3">
        <div class="flex-shrink-0">
          <%= if @announcement.organization.logo do %>
            <div class="relative mr-2 h-8 w-8 flex-shrink-0 rounded-full bg-zinc-200 md:h-10 md:w-10">
              <img class="h-8 w-8 rounded-full object-center md:h-10 md:w-10" src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} />
            </div>
          <% else %>
            <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-zinc-200 md:h-10 md:w-10">
              <span class="text-xs font-medium leading-none text-zinc-600">
                <%= extract_initials(@announcement.organization.name) %>
              </span>
            </span>
          <% end %>
        </div>
        <div class="min-w-0 flex-1">
          <p class="text-sm font-medium text-gray-900">
            <a href="#" class="hover:underline"><%= @announcement.organization.name %></a>
          </p>
          <p class="text-sm text-gray-500">
            <time><%= relative_datetime(@announcement.inserted_at) %></time>
          </p>
        </div>
      </div>
      <h2 class="mt-4 text-base font-semibold text-gray-900"><%= @announcement.title %></h2>
    </div>
    <div class="mt-2 space-y-4 text-justify text-sm text-gray-700">
      <%= @announcement.description %>
    </div>
    """
  end
end
