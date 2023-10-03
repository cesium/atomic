defmodule AtomicWeb.Components.Board do
  @moduledoc false
  use AtomicWeb, :component

  def member_bubble(assigns) do
    ~H"""
    <div class="mx-auto mt-12 mb-12 w-full px-4 sm:w-6/12 md:w-1/3 lg:1/4 lg:mb-0 xl:w-2/12">
      <%= if @user_organization.user.profile_picture do %>
        <img class="mx-auto h-56 w-56 rounded-full object-cover shadow-lg md:h-48 md:w-48" src={Uploaders.ProfilePicture.url({@user_organization.user.profile_picture, @user_organization.user}, :original)} />
      <% else %>
        <div class="flex items-center justify-center">
          <span class="flex h-28 w-28 items-center justify-center rounded-full bg-zinc-200 text-zinc-700">
            <%= extract_initials(@user_organization.user.name) %>
          </span>
        </div>
      <% end %>
      <div class="p-4 text-center">
        <p class="text-3xl font-bold md:text-2xl lg:text-xl"><%= @user_organization.user.name %></p>
        <p class="mt-1 text-lg font-semibold uppercase text-zinc-600 md:text-md lg:text-sm">
          <%= @user_organization.role %>
        </p>
      </div>
    </div>
    """
  end
end
