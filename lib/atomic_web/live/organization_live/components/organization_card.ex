defmodule AtomicWeb.OrganizationLive.Components.OrganizationCard do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Organizations.Organization

  import AtomicWeb.OrganizationLive.Components.OrganizationBannerPlaceholder

  attr :organization, Organization, required: true, doc: "The organization to display."

  def organization_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="h-14 w-full object-cover">
        <.organization_banner_placeholder organization={@organization} class="rounded-t-lg" />
      </div>
      <div class="p-4">
        <p class="text-lg font-semibold text-zinc-900">
          <%= @organization.name %>
        </p>
        <div class="mb-2 flex flex-row items-center">
          <p class="text-sm text-zinc-400">
            <%= @organization.long_name %>
          </p>
        </div>
        <div class="mt-4 text-justify text-sm text-zinc-600">
          <%= @organization.description %>
        </div>
      </div>
    </div>
    """
  end
end
