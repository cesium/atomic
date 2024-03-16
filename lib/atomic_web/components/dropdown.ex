defmodule AtomicWeb.Components.Dropdown do
  @moduledoc false
  use AtomicWeb, :component

  alias Phoenix.LiveView.JS

  attr :id, :string, required: true, doc: "The id of the dropdown."
  attr :image, :string, default: "", doc: "The image of the dropdown."
  attr :items, :list, default: [], doc: "The items to display in the dropdown."

  attr :orientation, :atom,
    required: true,
    doc: "The orientation of the dropdown.",
    values: [:down, :up]

  slot :inner_block, required: true, doc: "Slot for the body content of the dropdown."

  def dropdown(assigns) do
    ~H"""
    <div class="relative inline-block text-left" phx-click={JS.toggle(to: "##{assigns.id}", in: "block", out: "hidden")} phx-click-away={JS.hide(to: "##{assigns.id}")}>
      <%= render_slot(@inner_block) %>
      <div id={assigns.id} class={"#{if assigns.orientation == :down, do: "origin-top-right", else: "origin-bottom-right bottom-full"} absolute right-0 mt-2 hidden w-56 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5"}>
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
