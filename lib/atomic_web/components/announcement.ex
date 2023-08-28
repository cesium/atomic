defmodule AtomicWeb.Components.Announcement do
  @moduledoc false
  use AtomicWeb, :component

  def announcement(assigns) do
    organization = assigns.news.organization

    ~H"""
    <%= live_redirect to: @url, class: "group" do %>
      <li id={"announcement-#{@news.id}"} class="relative py-5 pr-6 pl-4 border-b border-gray-200 sm:py-6 sm:pl-6 lg:pl-8 xl:pl-6 hover:bg-gray-50">
        <div>
          <h3 class="text-sm font-semibold text-gray-800 hover:underline focus:outline-none">
            <%= @news.title %>
          </h3>
          <article class="mt-1 text-sm text-gray-600 line-clamp-3">
            <dd class="text-sm text-gray-500"><%= maybe_slice_string(@news.description, 250) %></dd>
          </article>
        </div>
        <div class="flex flex-shrink-0 justify-between mt-1">
          <div class="flex items-center">
            <%= if is_nil(organization.logo) do %>
              <span class="inline-flex justify-center items-center mr-2 w-6 h-6 bg-gray-500 rounded-full">
                <span class="text-xs font-medium leading-none text-white">
                  <%= extract_initials(organization.name) %>
                </span>
              </span>
            <% else %>
              <div class="relative flex-shrink-0 mr-2 w-6 h-6 bg-white rounded-full">
                <img src={Uploaders.Logo.url({organization.logo, organization}, :original)} class="object-center w-6 h-6 rounded-full" />
              </div>
            <% end %>
            <p class="text-sm text-gray-500">
              <%= organization.name %>
            </p>
          </div>
          <div class="flex">
            <Heroicons.Solid.calendar class="w-5 h-5 text-gray-500" />
            <p class="block pl-1.5 text-sm text-gray-600">
              <%= relative_datetime(@news.publish_at) %>
            </p>
          </div>
        </div>
      </li>
    <% end %>
    """
  end
end
