defmodule AtomicWeb.Components.Dropdown do
  @moduledoc """
  A customizable dropdown component for displaying a list of items, with flexible styling and behavior options.
  """
  use Phoenix.Component

  import AtomicWeb.Components.Icon
  alias Phoenix.LiveView.JS

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
    <div class="relative inline-block text-left" phx-click-away={JS.hide(to: "##{@id}", transition: {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"})}>
      <div phx-click={JS.toggle(to: "##{@id}", in: {"ease-out duration-100", "transform opacity-0 scale-95", "transform opacity-100 scale-100"}, out: {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"}, display: "block")}>
        {render_slot(@wrapper)}
      </div>
      <div id={@id} class={"#{if @orientation == :down, do: "top-full mt-2 origin-top", else: "bottom-full mb-2 origin-bottom"} shadow-zinc-400/50 absolute right-0 z-10 hidden w-full min-w-fit rounded-md bg-white shadow-lg ring-1 ring-zinc-300"}>
        <div class="p-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
          <%= for item <- @items do %>
            <%= if item[:patch] || item[:navigate] || item[:href] || item[:phx_click] do %>
              <.link
                patch={item[:patch]}
                navigate={item[:navigate]}
                href={item[:href]}
                phx-click={
                  if item[:phx_click] do
                    JS.push(item[:phx_click]) |> JS.hide(to: "##{@id}", transition: {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"})
                  else
                    JS.hide(to: "##{@id}", transition: {"ease-in duration-75", "transform opacity-100 scale-100", "transform opacity-0 scale-95"})
                  end
                }
                class={"#{item[:class]} flex items-center gap-x-2 rounded-sm p-2 text-sm text-zinc-700 hover:bg-zinc-100 hover:text-zinc-900"}
                role="menuitem"
                method={Map.get(item, :method, "get")}
              >
                <%= if item[:icon] do %>
                  <.icon name={item.icon} class={"#{item[:icon_class]} size-5 inline-block"} />
                <% end %>
                {item.name}
              </.link>
            <% else %>
              <div class={"#{item[:class]} flex items-center gap-x-2 px-4 py-2 text-sm text-zinc-700"}>
                <%= if item[:icon] do %>
                  <.icon name={item.icon} class="size-5 ml-2 inline-block" />
                <% end %>
                {item.name}
              </div>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
