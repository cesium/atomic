defmodule AtomicWeb.Components.OrganizationPlaceholder do
  @moduledoc """
  """
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="organization_placeholder">
      <% IO.inspect(assigns) %>
      <%= if @current_organization do %>
        <button @click="open = !open" @keydown.escape.stop="open = false" @keydown.enter.prevent="open = !open" type="button" class="group w-full bg-zinc-50 px-5 py-3 text-left text-sm font-medium text-zinc-700 hover:bg-zinc-100" id="options-menu-button" aria-expanded="false" aria-haspopup="true">
          <span class="flex w-full items-center justify-between ">
            <span class="flex min-w-0 items-center justify-between space-x-3">
              <%= if @current_organization.logo do %>
                <span class="inline-flex justify-center items-center w-10 h-10 rounded-lg">
                  <img src={Atomic.Uploaders.Logo.url({@current_organization.logo, @current_organization}, :original)} class="w-10 h-10 rounded-lg" />
                </span>
              <% else %>
                <span class="inline-flex justify-center items-center w-10 h-10 bg-zinc-300 rounded-lg">
                  <span class="text-lg font-medium leading-none text-white">
                    <%= Atomic.Accounts.extract_initials(@current_organization.name) %>
                  </span>
                </span>
              <% end %>
              <span class="flex min-w-0 flex-1 flex-col">
                <span class="truncate text-lg font-bold text-zinc-900">
                  <%= @current_organization.name %>
                </span>
                <span class="truncate text text-zinc-500">
                  <%= AtomicWeb.ViewUtils.capitalize_first_letter(Atomic.Organizations.get_role(@current_user.id, @current_organization.id)) %>
                </span>
              </span>
            </span>
            <svg class="h-5 w-5 flex-shrink-0 text-zinc-400 group-hover:text-zinc-500 group-focus:text-zinc-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path
                fill-rule="evenodd"
                d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"
                clip-rule="evenodd"
              />
            </svg>
          </span>
        </button>
      <% else %>
        <button @click="open = !open" @keydown.escape.stop="open = false" @keydown.enter.prevent="open = !open" type="button" class="group w-full bg-zinc-50 px-5 py-3 text-left text-sm font-medium text-zinc-700 hover:bg-zinc-100" id="options-menu-button" aria-expanded="false" aria-haspopup="true">
          <span class="flex w-full items-center justify-between ">
            <span class="flex min-w-0 items-center justify-between space-x-3">
              <%!-- <%= if @current_user.picture do %> --%>
              <%!-- <span class="inline-flex justify-center items-center w-10 h-10 rounded-lg"> --%>
              <%!-- <img src={Atomic.Uploaders.Logo.url({@current_organization.logo, @current_organization}, :original)} class="w-10 h-10 rounded-lg" /> --%>
              <%!-- </span> --%>
              <%!-- <% else %> --%>
              <span class="inline-flex justify-center items-center w-10 h-10 bg-zinc-500 rounded-full">
                <span class="text-lg font-medium leading-none text-white">
                  <%= Atomic.Accounts.extract_initials(@current_user.name) %>
                </span>
              </span>
              <%!-- <% end %> --%>
              <span class="flex min-w-0 flex-1 flex-col">
                <span class="truncate text-lg font-bold text-zinc-900">
                  <%= @current_user.name %>
                </span>
                <span class="truncate text text-zinc-500">
                  <%= @current_user.course.name %>
                </span>
              </span>
            </span>
            <%= if @current_user.organizations != [] do %>
              <svg class="h-5 w-5 flex-shrink-0 text-zinc-400 group-hover:text-zinc-500 group-focus:text-zinc-500" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"
                  clip-rule="evenodd"
                />
              </svg>
            <% end %>
          </span>
        </button>
      <% end %>
    </div>
    """
  end
end
