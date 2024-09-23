defmodule AtomicWeb.Components.Dropdown do
  @moduledoc """
  A customizable dropdown component for displaying a list of items, with flexible styling and behavior options.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  import AtomicWeb.Components.Icon

  attr :id, :string, required: true, doc: "The id of the dropdown."

  attr :items, :list, default: [], doc: "The items to display in the dropdown."

  attr :orientation, :atom,
    default: :down,
    doc: "The orientation of the dropdown.",
    values: [:down, :up]

  slot :wrapper,
    required: true,
    doc: "Slot to be rendered as a wrapper of the dropdown. For example, a custom button."

  def dropdown(assigns) do
    ~H"""
    <div class="relative inline-block text-left" phx-click-away={hide(@id)}>
      <div phx-click={JS.toggle(to: "##{@id}", in: {"ease-out duration-100", "transform opacity-0 scale-95", "transform opacity-100 scale-100"}, out: {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"}, display: "block")}>
        <%= render_slot(@wrapper) %>
      </div>

      <div id={@id} class={"#{if @orientation == :down, do: "origin-top-right top-full mt-2", else: "origin-bottom-right bottom-full mb-3"} absolute right-0 z-10 hidden w-56 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5"}>
        <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
          <%= for item <- @items do %>
            <%= if item[:patch] || item[:navigate] || item[:href] || item[:phx_click] do %>
              <.link patch={item[:patch]} navigate={item[:navigate]} href={item[:href]} phx-click={maybe_phx_click(item, @id)} class={"#{item[:class]} flex items-center gap-x-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900"} role="menuitem" method={Map.get(item, :method, "get")}>
                <%= if item[:icon] do %>
                  <.icon name={item.icon} class="size-5 ml-2 inline-block" />
                <% end %>
                <%= item.name %>
              </.link>
            <% else %>
              <div class={"#{item[:class]} flex items-center gap-x-2 px-4 py-2 text-sm text-gray-700"}>
                <%= if item[:icon] do %>
                  <.icon name={item.icon} class="size-5 ml-2 inline-block" />
                <% end %>
                <%= item.name %>
              </div>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp maybe_phx_click(item, id) when is_map_key(item, :phx_click) do
    if item[:value] do
      JS.push(item[:phx_click], value: item[:value]) |> hide(id)
    else
      JS.push(item[:phx_click])
    end
  end

  defp maybe_phx_click(item, id), do: hide(id)

  defp hide(id),
    do:
      JS.hide(
        to: "##{id}",
        transition:
          {"ease-in duration-75", "transform opacity-100 scale-100",
           "transform opacity-0 scale-95"}
      )

  defp hide(event, id) do
    event
    |> JS.hide(
      to: "##{id}",
      transition:
        {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"}
    )
  end
end
