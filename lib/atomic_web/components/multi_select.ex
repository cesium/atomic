defmodule AtomicWeb.Components.MulitSelect do
  @moduledoc """
  A multi-select component that allows you to select multiple items from a list.
  The component attributes are:
    @items - a list of items to be displayed in the dropdown in the format of %{id: id, label: label, selected: selected}
    @selected_items - the number of items selected
    @target - the target to send the event to

  The component events are:
    toggle_option - toggles the selected state of an item. This event should be defined in the component that you passed in the @target attribute.
  """

  use AtomicWeb, :live_component
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-1">
      <div>
        <span class="font-sm pl-1 text-base text-gray-800 sm:text-lg">
          Speakers
        </span>
        <div class="relative mt-2">
          <button
            class="relative w-64 cursor-default rounded-md bg-white py-1.5 pr-10 pl-3 text-left text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-orange-500 sm:text-sm sm:leading-6"
            id="button"
            type="button"
            phx-click={JS.toggle(to: "#dropdown")}
            aria-labelledby="listbox-label"
          >
            <span class="font-sm block truncate pl-1 text-base sm:text-lg">
              <%= if @selected_items == 0 do %>
                None selected
              <% else %>
                <%= "#{@selected_items} selected" %>
              <% end %>
            </span>
            <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
              <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z"
                  clip-rule="evenodd"
                />
              </svg>
            </span>
          </button>

          <ul
            id="dropdown"
            phx-click-away={JS.hide(to: "#dropdown")}
            class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
            role="listbox"
            aria-labelledby="listbox-label"
            aria-activedescendant="listbox-option-3"
            style="display: none;"
          >
            <%= for item <- @items do %>
              <li class="flex cursor-pointer select-none items-center justify-between py-2 pr-3 pl-3 text-gray-900" role="option" phx-target={@target} phx-click={JS.push("toggle_option", value: %{id: item.id})}>
                <span class="block truncate font-normal">
                  <%= item.label %>
                </span>

                <span class={
                  if item.selected do
                    "inset-y-0 right-0 flex-row pr-4 text-indigo-600"
                  else
                    "hidden"
                  end
                }>
                  <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z" clip-rule="evenodd" />
                  </svg>
                </span>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
