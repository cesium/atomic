defmodule AtomicWeb.Components.Announcement do
  @moduledoc false
  use AtomicWeb, :component

  def render_announcement(
        %{
          announcement: announcement,
          url: url
        } = assigns
      ) do
    organization = announcement.organization

    ~H"""
    <%= live_redirect to: url, class: "group" do %>
      <li id={"announcement-#{announcement.id}"} class="relative py-5 pr-6 pl-4 border-b border-zinc-200 sm:py-6 sm:pl-6 lg:pl-8 xl:pl-6 hover:bg-zinc-50">
        <div>
          <h3 class="text-sm font-semibold text-zinc-800 hover:underline focus:outline-none">
            <%= announcement.title %>
          </h3>
          <article class="mt-1 text-sm text-zinc-600 line-clamp-3">
            <dd class="text-sm text-zinc-500"><%= maybe_slice_string(announcement.description, 250) %></dd>
          </article>
        </div>
        <div class="flex flex-shrink-0 justify-between mt-1">
          <div class="flex items-center">
            <%= if organization.logo do %>
              <div class="relative flex-shrink-0 mr-2 w-6 h-6 bg-white rounded-full">
                <img src={Uploaders.Logo.url({organization.logo, organization}, :original)} class="object-center w-6 h-6 rounded-full" />
              </div>
            <% else %>
              <span class="inline-flex justify-center items-center mr-2 w-6 h-6 bg-zinc-500 rounded-full">
                <span class="text-xs font-medium leading-none text-white">
                  <%= extract_initials(organization.name) %>
                </span>
              </span>
            <% end %>
            <p class="text-sm text-zinc-500">
              <%= organization.name %>
            </p>
          </div>
          <div class="flex">
            <Heroicons.Solid.calendar class="w-5 h-5 text-zinc-500" />
            <p class="block pl-1.5 text-sm text-zinc-600">
              <%= relative_datetime(announcement.publish_at) %>
            </p>
          </div>
        </div>
      </li>
    <% end %>
    """
  end
end
