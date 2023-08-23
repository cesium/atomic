defmodule AtomicWeb.Components.Header do
  @moduledoc """
  This component is used to render the header of pages.
  """
  use AtomicWeb, :component
  alias Atomic.Organizations
  import AtomicWeb.Gettext

    def header(
      %{
        current_user: current_user,
        current_organization: current_organization,
        socket: socket,
        first_tab: first_tab,
        second_tab: second_tab,
        first_text: first_text,
        second_text: second_text,
        button_text: button_text,
        route: route
      } = assigns
    ) do

      ~H"""
      <div x-data="{ open: true }" class="bg-white">
        <div class="pt-4 px-4">
          <div class="flex items-center justify-between">
            <div class="min-w-0 flex-1">
              <h2 class="text-xl font-bold leading-7 text-zinc-900 sm:truncate sm:text-4xl">
                <%= gettext("%{first_text}", first_text: first_text) %>
              </h2>
            </div>
            <%= if Organizations.get_role(current_user.id, current_organization.id) in [:owner, :admin] or current_user.role in [:admin] do %>
              <div class="hidden lg:border-orange-500 lg:block">
                <%= live_patch("#{button_text}",
                  to: route,
                  class: "border-2 rounded-md bg-white text-lg border-orange-500 py-2 px-3.5 text-sm font-medium text-orange-500 shadow-sm hover:bg-orange-500 hover:text-white"
                ) %>
              </div>
            <% end %>
          </div>
          <div class="flex flex-col-reverse border-b border-zinc-200 xl:flex-row">
            <div x-data="{option: #{second_tab}}" class="flex w-full items-center justify-between">
              <nav class="-mb-px flex flex-1 space-x-6 overflow-x-auto xl:space-x-8" aria-label="Tabs">
                <div x-on:click="option = '#{second_tab}'" x-bind:class="option == #{second_tab} ? 'border-zinc-800' : 'border-transparent'" phx-click="open-enrollments" class="text-zinc-500 hover:text-zinc-700 whitespace-nowrap border-b-2 px-1 py-4 text-sm font-medium cursor-pointer">
                  <%= gettext("Open Enrollments") %>
                </div>

                <div x-on:click="option = '#{activities}" x-bind:class="option == #{first_tab} ? 'border-zinc-800' : 'border-transparent'" phx-click="activities-enrolled" class="text-zinc-500 hover:text-zinc-700 whitespace-nowrap border-b-2 px-1 py-4 text-sm font-medium cursor-pointer">
                  <%= gettext("Activities Enrolled") %>
                </div>
              </nav>
            </div>
          </div>
        </div>
      </div>
      """
    end
end
