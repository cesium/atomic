defmodule AtomicWeb.Components.Board do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :user_organization, :map, required: true

  def member_bubble(assigns) do
    ~H"""
    <div class="mx-auto mt-12 mb-12 w-full px-4 sm:w-6/12 md:w-1/3 lg:1/4 lg:mb-0 xl:w-2/12">
      <.avatar class="mx-auto text-white" color="zinc-400" name={@user_organization.user.name} size={:xl} src={Uploaders.ProfilePicture.url({@user_organization.user.profile_picture, @user_organization.user}, :original)} />
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
