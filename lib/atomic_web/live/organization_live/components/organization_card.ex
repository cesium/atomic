defmodule AtomicWeb.OrganizationLive.Components.OrganizationCard do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Organizations.Organization

  import AtomicWeb.Components.Button
  import AtomicWeb.OrganizationLive.Components.OrganizationBannerPlaceholder

  attr :organization, Organization, required: true, doc: "The organization to display."

  def organization_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="h-28 w-full object-cover">
        <.organization_banner_placeholder organization={@organization} class="rounded-t-lg" />
      </div>
      <div class="p-4">
        <div class="relative flex w-full">
          <div class="flex flex-1">
            <div class="-mt-[6rem]">
              <div class="relative rounded-full">
                <img class="size-32 relative rounded-lg border border-zinc-200" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-aaKrOSMD7Wf0JGMgncPHLPZ-aHgbMgY0sw&usqp=CAU" />
                <div class="absolute"></div>
              </div>
            </div>
            <p class="ml-3 text-lg font-semibold text-zinc-900">
              <%= @organization.name %>
            </p>
          </div>
          <div class="flex flex-col text-right">
            <.button>
              Follow
            </.button>
          </div>
        </div>
        <div class="mt-2 flex flex-row items-center">
          <p class="text-sm text-zinc-400">
            <%= @organization.long_name %>
          </p>
        </div>
        <ul role="list" class="mt-1 flex flex-col md:flex-row space-y-1 md:space-x-6">
          <li class="flex items-center space-x-1">
            <.icon name={:users} outline class="h-4 w-4" />
            <p class="text-sm">
              <span class="font-semibold">103</span> followers
            </p>
          </li>
          <li class="flex items-center space-x-1">
            <.icon name={:map_pin} outline class="h-4 w-4" />
            <p class="text-sm">Building 7, 1.04</p>
          </li>
          <li class="flex items-center space-x-1">
            <.icon name={:link} outline class="h-4 w-4" />
            <%!-- FIXME: Should be an href --%>
            <p class="text-sm hover:underline">https://cesium.di.uminho.pt</p>
          </li>
          <%!-- TODO: List all other socials --%>
        </ul>
      </div>
    </div>
    """
  end
end
