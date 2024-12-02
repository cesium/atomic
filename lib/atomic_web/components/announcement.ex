defmodule AtomicWeb.Components.Announcement do
  @moduledoc """
  Renders an announcement.
  """
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :announcement, :map, required: true, doc: "The announcement to render."

  def announcement(assigns) do
    ~H"""
    <div>
      <div class="flex space-x-3">
        <div class="my-auto flex-shrink-0">
          <.avatar name={@announcement.organization.name} color={:light_zinc} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} />
        </div>
        <div class="min-w-0 flex-1">
          <object>
            <.link navigate={~p"/organizations/#{@announcement.organization.id}"} class="hover:underline focus:outline-none">
              <p class="text-sm font-medium text-zinc-900">
                <%= @announcement.organization.name %>
              </p>
            </.link>
          </object>
          <p class="text-sm text-zinc-500">
            <span class="sr-only">Published on</span>
            <time><%= relative_datetime(@announcement.inserted_at) %></time>
          </p>
        </div>
      </div>
      <h2 class="mt-3 text-base font-semibold text-zinc-900"><%= @announcement.title %></h2>
      <div class="space-y-4 text-justify text-sm text-zinc-700 overflow-hidden break-words">
        <%= maybe_slice_string(@announcement.description, 300) %>
      </div>
      <!-- Image -->
      <%= if @announcement.image do %>
        <div class="mt-4">
          <img class="max-w-screen max-h-[32rem] rounded-md object-cover sm:max-w-xl" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} />
        </div>
      <% end %>
    </div>
    """
  end
end
