defmodule AtomicWeb.HomeLive.Components.FollowSuggestions do
  @moduledoc false
  use AtomicWeb, :component

  attr :organizations, :list,
    required: true,
    doc: "Organizations displayed as follow suggestions."

  def follow_suggestions(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <p class="text-lg font-semibold text-gray-900">
        Organizations to follow
      </p>
      <div class="flow-root">
        <ul role="list" class="divide-y divide-gray-200">
          <%= for organization <- @organizations do %>
            <li class="flex items-center space-x-3 py-4">
              <div class="flex-shrink-0">
                <%= if organization.logo do %>
                  <img class="h-8 w-8 rounded-full" src={Uploaders.Logo.url({organization, organization.logo}, :original)} alt={organization.name} />
                <% else %>
                  <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-gray-500">
                    <span class="text-sm font-medium leading-none text-white">
                      <%= extract_initials(organization.name) %>
                    </span>
                  </span>
                <% end %>
              </div>
              <div class="min-w-0 flex-1">
                <p class="text-sm font-medium text-gray-900">
                  <%= organization.name %>
                </p>
                <p class="text-sm text-gray-500">
                  <!-- FIXME: organization.handle -->
                  <%= ("@" <> organization.name) |> String.downcase() |> String.replace(" ", "") %>
                </p>
              </div>
              <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, organization)}>
                <div class="flex-shrink-0">
                  <button type="button" class="inline-flex items-center gap-x-1.5 text-sm font-semibold leading-6 text-gray-900">
                    <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
                    </svg>
                    Follow
                  </button>
                </div>
              </.link>
            </li>
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
