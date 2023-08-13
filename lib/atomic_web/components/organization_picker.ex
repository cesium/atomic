defmodule AtomicWeb.Components.OrganizationPicker do
  @moduledoc """
  This component is used to render the list of organizations in the sidebar.
  """
  use Phoenix.LiveComponent

  alias Atomic.Organizations
  alias Atomic.Uploaders.Logo

  def render(assigns) do
    ~H"""
    <div class="organization_picker">
      <%= if @current_organization do %>
        <div role="none">
          <a phx-target={@myself} phx-click="delete_current_organization" class="cursor-pointer w-full text-zinc-700 block px-4 py-2 text-sm hover:bg-zinc-100" role="menuitem" tabindex="-1" id="options-menu-item-0">
            <span class="flex w-full items-center justify-between">
              <span class="flex min-w-0 items-center justify-between space-x-3">
                <%!-- ADD USER PHOTO --%>
                <%!-- <img src={Logo.url({organization.logo, organization}, :original)} class="w-10 h-10 rounded-lg" /> --%>
                <span class="inline-flex justify-center items-center mr-1.5 w-10 h-10 bg-zinc-500 rounded-full">
                  <span class="text-lg font-medium leading-none text-white">
                    <%= Atomic.Accounts.extract_initials(@current_user.name) %>
                  </span>
                </span>
                <%!-- <% end %> --%>
                <span class="flex min-w-0 flex-1 flex-col">
                  <span class="truncate text-md font-medium text-zinc-900"></span>
                  <span class="truncate text-sm text-zinc-600">
                    <%= @current_user.name %>
                  </span>
                  <span class="truncate text-xs text-zinc-500">
                    Software Engineering
                  </span>
                </span>
              </span>
            </span>
          </a>
        </div>
      <% end %>
      <%= for organization <- @current_user.organizations do %>
        <%= if true do %>
          <div role="none">
            <a phx-target={@myself} phx-click="update_current_organization" phx-value-organization_id={organization.id} class="cursor-pointer w-full text-zinc-700 block px-4 py-2 text-sm hover:bg-zinc-100" role="menuitem" tabindex="-1" id="options-menu-item-0">
              <span class="flex w-full items-center justify-between">
                <span class="flex min-w-0 items-center justify-between space-x-3">
                  <%= if organization.logo do %>
                    <img src={Logo.url({organization.logo, organization}, :original)} class="w-10 h-10 rounded-lg" />
                  <% else %>
                    <span class="inline-flex justify-center items-center mr-1.5 w-10 h-10 bg-zinc-500 rounded-lg">
                      <span class="text-lg font-medium leading-none text-white">
                        <%= Atomic.Accounts.extract_initials(organization.name) %>
                      </span>
                    </span>
                  <% end %>
                  <span class="flex min-w-0 flex-1 flex-col">
                    <span class="truncate text-md font-medium text-zinc-900"></span>
                    <span class="truncate text-sm text-zinc-600">
                      <%= organization.name %>
                    </span>
                    <span class="truncate text-xs text-zinc-500">
                      <%= AtomicWeb.ViewUtils.capitalize_first_letter(Atomic.Organizations.get_role(@current_user.id, organization.id)) %>
                    </span>
                  </span>
                </span>
              </span>
            </a>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("update_current_organization", %{"organization_id" => organization_id}, socket) do
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign(:current_organization, organization)}
  end

  def handle_event("delete_current_organization", _params, socket) do
    {:noreply,
     socket
     |> assign(:current_organization, nil)}
  end
end
