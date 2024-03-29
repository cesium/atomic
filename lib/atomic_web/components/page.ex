defmodule AtomicWeb.Components.Page do
  @moduledoc """
  Component for the main page layout.
  """
  use Phoenix.Component

  attr :title, :string, required: true, doc: "The title of the page."

  attr :bottom_border, :boolean,
    default: false,
    doc: "Whether to show a bottom border after the page header."

  slot :actions, optional: true, doc: "Slot for actions to be rendered in the page header."
  slot :inner_block, optional: true, doc: "Slot for the body content of the page."

  def page(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col items-stretch justify-between lg:flex-row">
      <div class={"#{if @bottom_border, do: 'border-b', else: ''} min-h-[100vh] flex w-full flex-col bg-white lg:flex-row lg:border-r"}>
        <main class="relative z-0 mb-10 flex-1 overflow-y-auto focus:outline-none xl:order-last">
          <div class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
            <div class="my-6 flex min-w-0 flex-row items-center justify-between">
              <h1 class="flex-1 select-none truncate text-2xl font-bold text-gray-900">
                <%= @title %>
              </h1>
              <%= render_slot(@actions) %>
            </div>
          </div>

          <%= render_slot(@inner_block) %>
        </main>
      </div>
    </div>
    """
  end
end
