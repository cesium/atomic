defmodule AtomicWeb.Components.Picker do
  @moduledoc false
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias Atomic.Organizations

  # TODO: After upgrading to LiveView 0.18, should use attr/3 macro instead (same for the other private components)
  @impl true
  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }" @click.away="open = false">
      <%= if count_user_organizations(@current_user) == 0 do %>
        <div class="group w-full bg-zinc-50 px-3 py-3 text-left text-sm font-medium text-zinc-700 hover:bg-zinc-100 focus:bg-zinc-300">
          <.render_user user={@current_user} />
        </div>
      <% else %>
        <button class="group w-full bg-zinc-50 px-3 py-3 text-left text-sm font-medium text-zinc-700 hover:bg-zinc-100 focus:bg-zinc-300" @click="open = !open" @keydown.escape.stop="open = false" @keydown.enter.prevent="open = !open">
          <%= if !@current_organization do %>
            <div class="flex items-center justify-center">
              <.render_user user={@current_user} />
              <svg class="h-5 w-5 flex-shrink-0 text-zinc-400 group-hover:text-zinc-500 group-focus:text-zinc-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          <% else %>
            <div class="flex items-center justify-center">
              <.render_organization organization={@current_organization} role={get_user_role_inside_organization(@current_user, @current_organization)} />
              <svg class="h-5 w-5 flex-shrink-0 text-zinc-400 group-hover:text-zinc-500 group-focus:text-zinc-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          <% end %>
        </button>
      <% end %>
      <div
        class="absolute right-0 left-0 z-10 mx-3 mt-1 origin-top divide-y divide-zinc-200 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
        @click="open = !open"
        @keydown.escape.stop="open = false"
        @keydown.enter.prevent="open = !open"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        x-show="open"
        role="menu"
        aria-orientation="vertical"
        aria-labelledby="options-menu-button"
        tabindex="-1"
      >
        <%= if @current_organization do %>
          <div role="none">
            <a phx-target={@myself} phx-click="delete-current-organization" class="cursor-pointer w-full text-zinc-700 block px-4 py-2 text-sm hover:bg-zinc-100">
              <.render_user user={@current_user} />
            </a>
          </div>
        <% end %>
        <%= for organization <- list_user_organizations(@current_user) do %>
          <div role="none">
            <a phx-target={@myself} phx-click="update-current-organization" phx-value-organization_id={organization.id} class="cursor-pointer w-full text-zinc-700 block px-4 py-2 text-sm hover:bg-zinc-100">
              <.render_organization organization={organization} role={get_user_role_inside_organization(@current_user, organization)} />
            </a>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp render_user(%{user: user} = assigns) do
    ~H"""
    <span class="flex w-full items-center justify-between">
      <span class="flex min-w-0 items-center justify-between space-x-3">
        <%= if user.profile_picture do %>
          <img src={Uploaders.ProfilePicture.url({user.profile_picture, user}, :original)} class="mr-1.5 w-10 h-10 rounded-full" />
        <% else %>
          <span class="inline-flex justify-center items-center mr-1.5 w-10 h-10 bg-zinc-500 rounded-full">
            <span class="text-lg font-medium leading-none text-white">
              <%= extract_initials(user.name) %>
            </span>
          </span>
        <% end %>
        <span class="flex min-w-0 flex-1 flex-col">
          <span class="truncate text-md font-medium text-zinc-900">
            <%= user.name %>
          </span>
          <%= if user.course do %>
            <span class="truncate text text-zinc-500">
              <%= user.course.name %>
            </span>
          <% end %>
        </span>
      </span>
    </span>
    """
  end

  defp render_organization(%{organization: organization, role: role} = assigns) do
    ~H"""
    <span class="flex w-full items-center justify-between">
      <span class="flex min-w-0 items-center justify-between space-x-3">
        <%= if organization.logo do %>
          <img src={Uploaders.Logo.url({organization.logo, organization}, :original)} class="mr-1.5 w-10 h-10 rounded-full" />
        <% else %>
          <span class="inline-flex justify-center items-center mr-1.5 w-10 h-10 bg-zinc-500 rounded-full">
            <span class="text-lg font-medium leading-none text-white">
              <%= extract_initials(organization.name) %>
            </span>
          </span>
        <% end %>
        <span class="flex min-w-0 flex-1 flex-col">
          <span class="truncate text-md font-medium text-zinc-900">
            <%= organization.name %>
          </span>
          <span class="truncate text text-zinc-500">
            <%= capitalize_first_letter(role) %>
          </span>
        </span>
      </span>
    </span>
    """
  end

  @impl true
  def handle_event("update-current-organization", %{"organization_id" => organization_id}, socket) do
    organization = Organizations.get_organization!(organization_id)
    Accounts.update_user(socket.assigns.current_user, %{current_organization_id: organization.id})

    {:noreply,
     socket
     |> assign(current_organization: organization)
     |> push_redirect(to: Routes.organization_show_path(socket, :show, organization))}
  end

  @impl true
  def handle_event("delete-current-organization", _, socket) do
    Accounts.update_user(socket.assigns.current_user, %{current_organization_id: nil})

    {:noreply,
     socket
     |> assign(current_organization: nil)
     |> push_redirect(to: Routes.home_index_path(socket, :index))}
  end

  defp list_user_organizations(user) do
    Organizations.list_user_organizations(user.id)
  end

  defp count_user_organizations(user) do
    Enum.count(Organizations.list_user_organizations(user.id))
  end

  defp get_user_role_inside_organization(user, organization) do
    Organizations.get_role(user.id, organization.id)
  end
end
