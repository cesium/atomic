defmodule AtomicWeb.Components.Page do
  @moduledoc """
  Component for the main page layout.
  """
  use Phoenix.Component

  attr :title, :string, required: true, doc: "The title of the page."
  attr :description, :string, required: false, default: nil, doc: "The description of the page."

  attr :bottom_border, :boolean,
    default: false,
    doc: "Whether to show a bottom border after the page header."

  slot :header, required: false, doc: "Slot for content to be rendered as the page header."

  slot :actions, required: false, doc: "Slot for actions to be rendered in the page header."
  slot :inner_block, required: false, doc: "Slot for the body content of the page."

  def page(assigns) do
    ~H"""
    <%= render_slot(@header) %>

    <div class="flex min-h-full flex-col items-stretch justify-between lg:flex-row">
      <div class="min-h-[100vh] flex w-full flex-col bg-white lg:flex-row lg:border-r">
        <main class="relative z-0 mb-10 flex-1 overflow-y-auto focus:outline-none xl:order-last">
          <div class={["mx-auto max-w-5xl px-4 sm:px-6 lg:px-8", @bottom_border && "border-b"]}>
            <div class="my-6 flex min-w-0 flex-row items-center justify-between">
              <div class="flex flex-col">
                <h1 class="flex-1 select-none truncate text-2xl font-bold text-zinc-900">
                  <%= @title %>
                </h1>
                <h3 :if={@description} class="flex-1 select-none truncate text-sm font-medium text-zinc-500">
                  <%= @description %>
                </h3>
              </div>
              <div class="flex space-x-4">
                <%= render_slot(@actions) %>
              </div>
            </div>
          </div>
          {render_slot(@inner_block)}
        </main>
      </div>
    </div>
    """
  end
end
