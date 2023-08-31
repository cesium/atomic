defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use AtomicWeb, :component

  def edit_button(assigns) do
    ~H"""
    <div class="flex w-0 flex-1">
      <%= live_patch to: @url, class: "relative -mr-px inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent py-4 text-sm font-medium hover:bg-zinc-50" do %>
        <Heroicons.Solid.pencil class="1.5xl:mr-3 w-5 h-5 text-zinc-400" />
        <p class="hidden lg:inline">Edit</p>
      <% end %>
    </div>
    """
  end

  def delete_button(assigns) do
    ~H"""
    <div class="-ml-px w-0 flex-1 flex">
      <div class="-ml-px w-0 flex-1 flex">
        <%= link(
          to: "#",
          phx_click: "delete",
          class: "w-full relative inline-flex flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent text-sm font-medium hover:bg-zinc-50",
          phx_value_id: @id,
          data: [confirm: "Are you sure?"]
        ) do %>
          <Heroicons.Solid.trash class="1.5xl:mr-3 w-5 h-5 text-zinc-400" />
          <p class="hidden lg:inline">Delete</p>
        <% end %>
      </div>
    </div>
    """
  end
end
