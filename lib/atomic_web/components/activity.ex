defmodule AtomicWeb.Components.Activity do
  @moduledoc """
  Renders an activity.
  """
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  alias Atomic.Activities.Activity

  attr :activity, :map, required: true, doc: "The activity to render."

  def activity(assigns) do
    ~H"""
    <div>
      <div class="flex space-x-3">
        <div class="my-auto flex-shrink-0">
          <.avatar name={@activity.organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@activity.organization.logo, @activity.organization}, :original)} />
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
          <img class="max-w-screen max-h-[32rem] rounded-md object-cover sm:max-w-xl" src={Uploaders.Post.url({@activity.image, @activity}, :original)} />
        </div>
      <% end %>
      <!-- Footer -->
      <div class={"#{footer_margin_top_class(@activity)} flex flex-row justify-between"}>
        <div class="flex space-x-4">
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2 text-zinc-400">
              <.icon name="hero-calendar-solid" class="mr-1.5 h-5 w-5 flex-shrink-0 text-zinc-400" />
              <span class="font-medium text-gray-900"><%= pretty_display_date(@activity.start) %></span>
              <span class="sr-only">starting in</span>
            </span>
          </span>
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2">
              <.icon
                name="hero-user-group-solid"
                class={[
                  "h-5 w-5",
                  color_class(@activity.enrolled, @activity.maximum_entries)
                ]}
              />
              <span class="font-medium text-gray-900"><%= @activity.enrolled %>/<%= @activity.maximum_entries %></span>
              <span class="sr-only text-zinc-400">enrollments</span>
            </span>
          </span>
          <span class="inline-flex items-center text-sm">
            <span class="inline-flex space-x-2 text-zinc-400">
              <.icon name="hero-map-pin-solid" class="size-5" />
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

  defp color_class(enrolled, maximum_entries) when enrolled == maximum_entries, do: "text-red-500"

  defp color_class(enrolled, maximum_entries) when enrolled > div(maximum_entries, 2),
    do: "text-amber-300"

  defp color_class(_, _), do: "text-lime-600"
end
