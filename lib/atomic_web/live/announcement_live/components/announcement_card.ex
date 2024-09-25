defmodule AtomicWeb.AnnouncementLive.Components.AnnouncementCard do
  @moduledoc false

  import AtomicWeb.Components.Avatar

  use AtomicWeb, :component

  def announcement_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg bg-white p-4">
      <.link navigate={Routes.announcement_show_path(AtomicWeb.Endpoint, :show, @announcement)}>
        <div class="mb-4 flex items-center space-x-2">
          <div class="flex-shrink-0">
            <.avatar name={@announcement.organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} />
          </div>
          <div>
            <p class="text-sm font-medium text-zinc-700"><%= @announcement.organization.name %></p>
            <p class="text-xs text-gray-500">
              <span class="sr-only">Published on</span>
              <time><%= relative_datetime(@announcement.inserted_at) %></time>
            </p>
          </div>
        </div>
        <div>
          <p class="text-lg font-semibold text-zinc-900" title={@announcement.title}>
            <%= @announcement.title %>
          </p>
          <p class="mt-2 text-sm leading-relaxed text-zinc-500">
            <%= @announcement.description %>
          </p>
        </div>
        <%= if @announcement.image do %>
          <div class="h-[250px] mt-4 overflow-hidden md:h-[450px]">
            <img class="h-full w-full rounded-md object-contain" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} alt="Announcement Image" />
          </div>
        <% end %>
      </.link>
    </div>
    """
  end
end
