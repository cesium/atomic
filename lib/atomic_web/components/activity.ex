defmodule AtomicWeb.Components.Activity do
  @moduledoc """
  Renders an activity.
  """
  use AtomicWeb, :component

  alias Atomic.Activities.Activity

  attr :activity, :map, required: true, doc: "The activity to render."

  def activity(assigns) do
    ~H"""
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
          <object>
            <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @activity.organization.id)}>
              <span class="text-sm font-medium text-gray-900 hover:underline focus:outline-none">
                <%= @activity.organization.name %>
              </span>
            </.link>
          </object>
          <p class="text-sm text-gray-500">
            <span class="sr-only">Published on</span>
            <time><%= relative_datetime(@activity.inserted_at) %></time>
          </p>
        </div>
      </div>
      <h2 class="mt-3 text-base font-semibold text-gray-900"><%= @activity.title %></h2>
      <div class="text-justify text-sm text-gray-700">
        <p><%= @activity.description %></p>
      </div>
      <!-- Image -->
      <%= if @activity.image do %>
        <div class="mt-4">
          <img class="max-w-screen rounded-md sm:max-w-xl" src={Uploaders.Post.url({@activity.image, @activity}, :original)} />
        </div>
      <% end %>
      <!-- Footer -->
      <div class={"#{footer_margin_top_class(@activity)} flex flex-row justify-between"}>
        <div class="flex space-x-4">
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2 text-zinc-400">
              <Heroicons.clock solid class="h-5 w-5" />
              <span class="font-medium text-gray-900"><%= relative_datetime(@activity.start) %></span>
              <span class="sr-only">starting in</span>
            </span>
          </span>
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2 text-zinc-400">
              <Heroicons.user_group solid class="h-5 w-5" />
              <span class="font-medium text-gray-900"><%= @activity.enrolled %>/<%= @activity.maximum_entries %></span>
              <span class="sr-only">enrollments</span>
            </span>
          </span>
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2 text-zinc-400">
              <Heroicons.map_pin solid class="h-5 w-5" />
              <span class="font-medium text-gray-900"><%= @activity.location.name %></span>
              <span class="sr-only">location</span>
            </span>
          </span>
        </div>
      </div>
    </div>
    """
  end

  defp footer_margin_top_class(%Activity{} = activity) do
    if activity.image do
      "mt-4"
    else
      "mt-2"
    end
  end
end
