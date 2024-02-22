defmodule AtomicWeb.Components.Tabs do
  @moduledoc false
  use AtomicWeb, :component

  attr :current_option, :string, required: true, doc: "The current selected option."
  attr :options, :map, required: true, doc: "A map of options and their respective callbacks."

  @doc """
    ## Example of options attr

    `
    options = %{
      "All" => "load-all",
      "Following" => "load-following"
    }
    `
  """
  def tabs(assigns) do
    ~H"""
    <section x-data={"{ option: #{@current_option} }"}>
      <div class="border-b border-gray-200">
        <div class="max-w-5-xl mx-auto flex flex-row items-center justify-between px-4 sm:px-6 lg:px-8">
          <div class="flex flex-col-reverse xl:flex-row">
            <div class="flex w-full items-center justify-between">
              <nav class="-mb-px flex space-x-8 overflow-x-auto" aria-label="Tabs">
                <%= for {option, callback} <- @options do %>
                  <button id={option} phx-click={callback} x-bind:class={"#{option == @current_option} ? 'border-b-2 border-orange-600 text-gray-900' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"} class="whitespace-nowrap px-1 py-4 text-sm font-medium text-gray-500">
                    <%= option %>
                  </button>
                <% end %>
              </nav>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
