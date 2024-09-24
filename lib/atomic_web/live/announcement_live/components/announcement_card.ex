defmodule AtomicWeb.AnnouncementLive.Components.AnnouncementCard do
  @moduledoc false
  use AtomicWeb, :component

  def announcement_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg hover:bg-zinc-50">
      <.link navigate={Routes.announcement_show_path(AtomicWeb.Endpoint, :show, @announcement)}>
        <div class="p-4">
          <p class="text-lg font-semibold text-zinc-900" title={@announcement.title}>
            <%= @announcement.title %>
          </p>
          <p class="mt-2 text-sm text-zinc-500">
            <%= @announcement.description %>
          </p>
          <object class="mt-2">
            <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @announcement.organization.id)} class="flex items-center">
              <.icon name="hero-building_office-solid" class="mr-1.5 h-5 w-5 text-zinc-400" />
              <span class="text-sm text-zinc-500 focus:outline-none">
                <%= @announcement.organization.name %>
              </span>
            </.link>
          </object>
        </div>
        <%= if @announcement.image do %>
          <div class="h-[250px] overflow-hidden md:h-[450px]">
            <img class="h-full w-full object-cover" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} alt="Announcement Image" />
          </div>
        <% end %>
      </.link>
    </div>
    """
  end
end
