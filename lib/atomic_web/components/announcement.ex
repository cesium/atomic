defmodule AtomicWeb.Components.Announcement do
  @moduledoc false
  use AtomicWeb, :component

  def render_announcement(assigns) do
    assigns = assign(assigns, :organization, assigns.announcement.organization)

    ~H"""
    <%= live_redirect to: @url, class: "group" do %>
      <li id={"announcement-#{@announcement.id}"} class="relative border-b border-zinc-200 py-5 pr-6 pl-4 hover:bg-zinc-50 sm:py-6 sm:pl-6 lg:pl-8 xl:pl-6">
        <div>
          <h3 class="text-sm font-semibold text-zinc-800 hover:underline focus:outline-none">
            <%= @announcement.title %>
          </h3>
          <article class="line-clamp-3 mt-1 text-sm text-zinc-600">
            <dd class="text-sm text-zinc-500"><%= maybe_slice_string(@announcement.description, 250) %></dd>
          </article>
        </div>
        <div class="mt-1 flex flex-shrink-0 justify-between">
          <div class="flex items-center">
            <%= if @organization.logo do %>
              <div class="relative mr-2 h-6 w-6 flex-shrink-0 rounded-full bg-white">
                <img src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} class="h-6 w-6 rounded-full object-center" />
              </div>
            <% else %>
              <span class="mr-2 inline-flex h-6 w-6 items-center justify-center rounded-full bg-zinc-500">
                <span class="text-xs font-medium leading-none text-white">
                  <%= extract_initials(@organization.name) %>
                </span>
              </span>
            <% end %>
            <p class="text-sm text-zinc-500">
              <%= @organization.name %>
            </p>
          </div>
          <div class="flex">
            <Heroicons.calendar solid class="h-5 w-5 text-zinc-500" />
            <p class="block pl-1.5 text-sm text-zinc-600">
              <%= relative_datetime(@announcement.publish_at) %>
            </p>
          </div>
        </div>
      </li>
    <% end %>
    """
  end
end
