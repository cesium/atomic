defmodule AtomicWeb.Components.Empty do
  @moduledoc """
  A component for displaying an empty state.
  """
  use AtomicWeb, :component

  alias Inflex

  attr :id, :string, default: "empty-state", required: false
  attr :placeholder, :string, required: true
  attr :url, :string, required: true

  def empty_state(assigns) do
    ~H"""
    <div id={@id} class="text-center">
      <.icon name="hero-plus-circle" class="size-12 mx-auto text-zinc-400" />
      <h3 class="mt-2 text-sm font-semibold text-zinc-900">No <%= plural(@placeholder) %></h3>
      <p class="mt-1 text-sm text-zinc-500">Get started by creating a new <%= @placeholder %>.</p>
      <div class="mt-4">
        <.link navigate={@url} class="inline-flex items-center rounded-md bg-orange-500 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-orange-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-orange-500">
          <svg class="size-5 mr-1.5 -ml-0.5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
          </svg>
          New <%= @placeholder %>
        </.link>
      </div>
    </div>
    """
  end

  # Returns the plural form of a word.
  @spec plural(String.t()) :: String.t()
  defp plural(word), do: Inflex.pluralize(word)
end
