defmodule AtomicWeb.OrganizationLive.Components.OrganizationCard do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Accounts.User
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Uploaders

  import AtomicWeb.Components.{Avatar, Button, Gradient}

  attr :organization, Organization, required: true, doc: "The organization to display"
  attr :current_user, User, required: false, default: nil, doc: "The current user, if any"

  def organization_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="h-32 w-full select-none">
        <!-- FIXME: Add banner support -->
        <%!-- <%= if @organization.banner do %>
          <img class="h-32 w-full object-cover" src={Uploaders.Banner.url({@organization.banner, @organization}, :original)} />
        <% else %> --%>
        <.gradient seed={@organization.id} class="rounded-t-lg" />
        <%!-- <% end %> --%>
      </div>

      <div class="p-4">
        <div class="relative flex w-full">
          <div class="flex flex-1">
            <div class="-mt-[6rem]">
              <div class={[
                "relative rounded-lg",
                @organization.logo && "bg-white"
              ]}>
                <.avatar name={@organization.name} color={:white} size={:lg} class="!size-32 p-1" type={:organization} src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} />
              </div>
            </div>
            <p class="ml-3 text-lg font-semibold text-zinc-900">
              <%= @organization.name %>
            </p>
          </div>

          <%!-- TODO: Maybe show button when there's no current user, but with a must login warning? --%>
          <%= if @current_user do %>
            <%= if Organizations.user_following?(@current_user.id, @organization.id) do %>
              <.button icon={:star} icon_variant={:solid}><%= gettext("Following") %></.button>
            <% else %>
              <.button icon={:star}><%= gettext("Follow") %></.button>
            <% end %>
          <% end %>
        </div>

        <p class="mt-2 text-sm text-zinc-400">
          <%= @organization.long_name %>
        </p>

        <div role="list" class="mt-2 flex flex-col space-y-2 md:flex-row md:items-center md:space-x-6 md:space-y-0">
          <ul class="flex flex-col space-y-2 md:flex-row md:items-center md:space-x-6 md:space-y-0">
            <li class="flex items-center space-x-1">
              <.icon name={:users} outline class="size-4" />
              <%= if @organization.follower_count != 1 do %>
                <p class="text-sm">
                  <span class="font-semibold"><%= @organization.follower_count %></span> followers
                </p>
              <% else %>
                <p class="text-sm">
                  <span class="font-semibold">1</span> follower
                </p>
              <% end %>
            </li>

            <li :if={@organization.location} class="flex items-center space-x-1">
              <.icon name={:map_pin} outline class="size-4" />
              <p class="text-sm"><%= @organization.location %></p>
            </li>
          </ul>

          <div :if={@organization.socials && @organization.socials.website} class="group">
            <.link href={@organization.socials.website} target="_blank" class="flex items-center space-x-1">
              <.icon name={:link} outline class="size-4" />
              <p class="text-sm group-hover:underline"><%= @organization.socials.website %></p>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
