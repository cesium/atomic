defmodule AtomicWeb.Components.Forms do
  @moduledoc false
  use AtomicWeb, :component

  def datetime_input(assigns) do
    ~H"""
    <div>
      <span class="font-sm pl-1 text-base text-gray-800 sm:text-lg">
        <%= @label %>
      </span>
      <div>
        <%= datetime_local_input(@forms, @id, phx_debounce: "blur", class: "block w-64 rounded-md border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500") %>
        <div class="text-red-500">
          <%= error_tag(@forms, @id) %>
        </div>
      </div>
    </div>
    """
  end

  def number_input(assigns) do
    ~H"""
    <div>
      <span class="font-sm pl-1 text-base text-gray-800 sm:text-lg">
        <%= @label %>
      </span>
      <div>
        <%= number_input(@forms, @id, prompt: @label, placeholder: @placeholder, class: "block w-64 rounded-md border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500") %>
        <div class="text-red-500">
          <%= error_tag(@forms, @id) %>
        </div>
      </div>
    </div>
    """
  end

  def text_input(assigns) do
    ~H"""
    <div>
      <span class="font-sm pl-1 text-base text-gray-800 sm:text-lg">
        <%= @label %>
      </span>
      <div>
        <%= text_input(@forms, @id, placeholder: @placeholder, phx_debounce: "blur", class: "block w-96 rounded-md border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 sm:w-80") %>
        <div class="flex text-red-500">
          <%= error_tag(@forms, @id) %>
        </div>
      </div>
    </div>
    """
  end

  def textarea(assigns) do
    ~H"""
    <div>
      <span class="line-clamp-3 text-sm text-gray-700">
        <span class="font-sm pl-1 text-base text-gray-800 sm:text-lg">
          <%= @label %>
        </span>
        <%= textarea(@forms, @id, placeholder: @placeholder, rows: @rows, phx_debounce: "blur", class: "h-32 w-full rounded-md border-gray-300 font-medium shadow-sm focus:border-orange-500 focus:ring-orange-500 sm:text-sm") %>
      </span>
      <div class="flex text-red-500">
        <%= error_tag(@forms, @id) %>
      </div>
    </div>
    """
  end
end
