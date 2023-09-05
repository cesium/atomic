defmodule AtomicWeb.Components.Pagination do
  @moduledoc false
  use AtomicWeb, :component

  alias Plug.Conn.Query

  import AtomicWeb.Components.Helpers

  def pagination(assigns) do
    ~H"""
    <div class={@class}>
      <nav class="mb-5 flex w-full items-center justify-between px-4">
        <%= if @meta.total_pages > 1 do %>
          <div class="-mt-px flex w-0 flex-1">
            <%= if @meta.has_previous_page? do %>
              <%= live_patch to: build_query(@meta.previous_page, @meta), class: "inline-flex items-center pt-4 pr-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
                <Heroicons.Solid.arrow_narrow_left class="mr-3 h-5 w-5 text-gray-400" />
              <% end %>
            <% end %>
          </div>
          <div class="flex select-none lg:-mt-px">
            <%= if max(1, @meta.current_page - 2) != 1 do %>
              <%= live_patch("1", to: build_query(1, @meta), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
              <%= if @meta.current_page - 2 > 2 do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                  ...
                </span>
              <% end %>
            <% end %>
            <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
              <%= if @meta.current_page == page do %>
                <%= live_patch("#{page}", to: build_query(page, @meta), class: "text-secondary inline-flex items-center px-4 pt-4 text-sm font-medium") %>
              <% else %>
                <%= live_patch("#{page}", to: build_query(page, @meta), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
              <% end %>
            <% end %>
            <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
              <%= if @meta.current_page + 3 < @meta.total_pages do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                  ...
                </span>
              <% end %>
              <%= live_patch("#{@meta.total_pages}", to: build_query(@meta.total_pages, @meta), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
            <% end %>
          </div>
          <div class="-mt-px flex w-0 flex-1 justify-end">
            <%= if @meta.has_next_page? do %>
              <%= live_patch to: build_query(@meta.next_page, @meta), class: "inline-flex items-center pt-4 pl-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
                <Heroicons.Solid.arrow_narrow_right class="ml-3 h-5 w-5 text-gray-400" />
              <% end %>
            <% end %>
          </div>
        <% end %>
      </nav>
    </div>
    """
  end

  defp build_query(page, meta) do
    meta.flop
    |> Flop.set_page(page)
    |> to_query(for: meta.schema)
    |> Query.encode()
    |> then(&"?#{&1}")
  end
end
