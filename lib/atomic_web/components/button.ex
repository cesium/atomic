defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Organizations

  def action(assigns) do
    ~H"""
    <div class="flex flex-1 flex-col p-2">
      <h3 class="mt-1 text-sm font-medium text-gray-900"><%= @title %></h3>
      <dl class="my-1 flex flex-grow flex-col justify-between">
        <dd class="text-sm text-gray-500"><%= @description %></dd>
      </dl>
    </div>

    <%= if Organizations.get_role(@current_user.id, @current_organization.id) in [:owner, :admin] or @current_user.role in [:admin] do %>
      <div>
        <div class="-mt-px flex divide-x divide-gray-200">
          <div class="flex w-0 flex-1">
            <%= live_patch to: @url, class: "relative -mr-px inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent py-4 text-sm font-medium hover:bg-gray-50" do %>
              <Heroicons.Solid.pencil class="1.5xl:mr-3 w-5 h-5 text-gray-400" />
              <p class="hidden lg:inline">Edit</p>
            <% end %>
          </div>
          <div class="-ml-px w-0 flex-1 flex">
            <div class="-ml-px w-0 flex-1 flex">
              <%= link(
                to: "#",
                phx_click: "delete",
                class: "w-full relative inline-flex flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent text-sm font-medium hover:bg-gray-50",
                phx_value_id: @id,
                data: [confirm: "Are you sure?"]
              ) do %>
                <Heroicons.Solid.trash class="1.5xl:mr-3 w-5 h-5 text-gray-400" />
                <p class="hidden lg:inline">Delete</p>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    <% end %>
    """
  end
end
