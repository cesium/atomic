defmodule AtomicWeb.Components.Dropdown do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.Icon

  attr :label, :string, required: true, doc: "The label of the dropdown."
  attr :image, :string, default: "", doc: "The image of the dropdown."

  attr :type, :atom,
    default: :button,
    values: [:button, :avatar],
    doc: "The type of the dropdown."

  attr :items, :list, default: [], doc: "The items to display in the dropdown."

  def dropdown(%{type: :avatar} = assigns) do
    ~H"""
    <div class="relative inline-block text-left">
      <button id={"dropdown-#{assigns.label}"} type="button" phx-hook="Dropdown" class="inline-flex h-10 w-10 justify-center rounded-3xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
        <%= if String.length(assigns.image) > 0 do %>
          <img class="h-8 w-8 rounded-full" src={assigns.image} alt="" />
        <% else %>
          <%= extract_initials(assigns.label) %>
        <% end %>
      </button>
      <div id="avatar" class="absolute right-0 mt-2 hidden w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5">
        <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
          <%= for item <- assigns.items do %>
            <a href={item.link} class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">
              <%= item.name %>
            </a>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def dropdown(%{type: :button} = assigns) do
    ~H"""
    <div class="relative inline-block text-left">
      <button id={"dropdown-#{assigns.label}"} type="button" phx-hook="Dropdown" class="inline-flex w-full justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50">
        <%= assigns.label %>
        <.icon name={:chevron_down} solid class="-mr-1 ml-2 h-5 w-5" />
      </button>
      <div id="button" class="absolute right-0 mt-2 hidden w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5">
        <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
          <%= for item <- assigns.items do %>
            <a href={item.link} class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">
              <%= item.name %>
            </a>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
