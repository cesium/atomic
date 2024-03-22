defmodule AtomicWeb.Components.Announcement do
  @moduledoc """
  Renders an announcement.
  """
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Popover}

  attr :announcement, :map, required: true, doc: "The announcement to render."

  def announcement(assigns) do
    ~H"""
    <div>
      <div class="flex">
        <div class="my-auto flex-shrink-0">
          <.popover type={:organization} organization={@announcement.organization} position={:bottom}>
            <:wrapper>
              <.avatar name={@announcement.organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} />
            </:wrapper>
          </.popover>
        </div>
        <div class="ml-3">
          <div class="min-w-0 flex-1">
            <object>
              <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @announcement.organization.id)} class="hover:underline focus:outline-none">
                <p class="text-sm font-medium text-gray-900">
                  <%= @announcement.organization.name %>
                </p>
              </.link>
            </object>
            <p class="text-sm text-gray-500">
              <span class="sr-only">Published on</span>
              <time><%= relative_datetime(@announcement.inserted_at) %></time>
            </p>
          </div>
        </div>
      </div>
      <h2 class="mt-3 text-base font-semibold text-gray-900"><%= @announcement.title %></h2>
      <div class="space-y-4 text-justify text-sm text-gray-700">
        <%= @announcement.description %>
      </div>
      <!-- Image -->
      <%= if @announcement.image do %>
        <div class="mt-4">
          <img class="max-w-screen rounded-md sm:max-w-xl" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} />
        </div>
      <% end %>
    </div>
    """
  end
end
