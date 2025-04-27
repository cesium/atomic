defmodule AtomicWeb.AnnouncementLive.Components.AnnouncementCard do
  @moduledoc false

  import AtomicWeb.Components.Avatar

  use AtomicWeb, :component

  def announcement_card(assigns) do
    ~H"""
    <div class="mt-4 flex flex-col justify-center rounded-lg bg-white md:mt-2 lg:p-4">
      <.link navigate={~p"/organizations/#{@organization}/announcements/#{@announcement}"} class="block">
        <div class="flex items-center space-x-2 px-4 py-1">
          <div class="flex-shrink-0">
            <.avatar name={@announcement.organization.name} color={:light_zinc} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} />
          </div>
          <div>
            <p class="text-sm font-medium text-zinc-700">{@announcement.organization.name}</p>
            <p class="text-xs text-gray-500">
              <span class="sr-only">Published on</span>
              <time>{relative_datetime(@announcement.inserted_at)}</time>
            </p>
          </div>
        </div>
        <div class="px-4 py-2">
          <p class="text-lg font-semibold text-zinc-900" title={@announcement.title}>
            {@announcement.title}
          </p>
          <p class="overflow-wrap mt-2 overflow-hidden break-all text-sm leading-relaxed text-zinc-700">
            {maybe_slice_string(@announcement.description, 300)}
          </p>
        </div>
        <%= if @announcement.image do %>
          <div class="h-auto w-full overflow-hidden px-4">
            <img class="max-h-[32rem] max-w-screen object-cover sm:max-w-xl md:rounded-xl" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} alt="Announcement Image" />
          </div>
        <% end %>
      </.link>
    </div>
    """
  end
end
