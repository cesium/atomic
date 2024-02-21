defmodule AtomicWeb.HomeLive.Components.FollowSuggestions do
  @moduledoc false
  use AtomicWeb, :live_component

  alias AtomicWeb.HomeLive.Components.FollowSuggestions.Organization

  attr :current_user, :map,
    required: true,
    doc: "The current user logged in."

  attr :organizations, :list,
    required: true,
    doc: "Organizations displayed as follow suggestions."

  @impl true
  def render(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <p class="text-lg font-semibold text-gray-900">
        Organizations to follow
      </p>
      <div class="flow-root">
        <ul role="list" class="divide-y divide-gray-200">
          <%= for organization <- @organizations do %>
            <.live_component id={organization.id} module={Organization} organization={organization} current_user={@current_user} />
          <% end %>
        </ul>
      </div>
      <div class="my-4">
        <.link patch={Routes.organization_index_path(AtomicWeb.Endpoint, :index)} class="flex w-full items-center justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-orange-500 shadow-sm hover:bg-gray-50">
          View all
        </.link>
      </div>
    </div>
    """
  end
end
