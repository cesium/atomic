defmodule AtomicWeb.Components.Card do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Organizations

  import AtomicWeb.Components.Button

  def card(assigns) do
    ~H"""
    <div class="col-span-1 flex flex-col divide-y divide-gray-200 rounded-lg bg-white text-center shadow">
      <div class="flex flex-1 flex-col p-2">
        <h3 class="mt-1 text-sm font-medium text-gray-900"><%= @title %></h3>
        <dl class="my-1 flex flex-grow flex-col justify-between">
          <dd class="text-sm text-gray-500"><%= @description %></dd>
        </dl>
      </div>

      <%= if Organizations.get_role(@current_user.id, @current_organization.id) in [:owner, :admin] or @current_user.role in [:admin] do %>
        <div>
          <div class="-mt-px flex divide-x divide-gray-200">
            <div class="-ml-px w-0 flex-1 flex">
              <.edit_button url={@url} />
              <.delete_button id={@id} />
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
