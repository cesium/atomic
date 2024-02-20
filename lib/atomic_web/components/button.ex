defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use AtomicWeb, :component

  attr :url, :string, required: true

  slot :inner_block, required: true

  def primary_button(assigns) do
    ~H"""
    <.link patch={@url} class="inline-flex items-center rounded-md bg-orange-500 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-orange-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-orange-500">
        <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  attr :url, :string, required: true

  def edit_button(assigns) do
    ~H"""
    <div class="flex w-0 flex-1">
      <.link patch={@url} class="relative -mr-px inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent py-4 text-sm font-medium hover:bg-zinc-50">
        <Heroicons.pencil solid class="h-5 w-5 text-zinc-400 1.5xl:mr-3" />
        <p class="hidden lg:inline">Edit</p>
      </.link>
    </div>
    """
  end

  attr :id, :string, required: true

  def delete_button(assigns) do
    ~H"""
    <div class="-ml-px flex w-0 flex-1">
      <div class="-ml-px flex w-0 flex-1">
        <%= link(
          to: "#",
          phx_click: "delete",
          class: "relative inline-flex w-full flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent text-sm font-medium hover:bg-zinc-50",
          phx_value_id: @id,
          data: [confirm: "Are you sure?"]
        ) do %>
          <Heroicons.trash solid class="h-5 w-5 text-zinc-400 1.5xl:mr-3" />
          <p class="hidden lg:inline">Delete</p>
        <% end %>
      </div>
    </div>
    """
  end
end
