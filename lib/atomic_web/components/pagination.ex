defmodule AtomicWeb.Components.Pagination do
  @moduledoc false
  use AtomicWeb, :component

  alias Plug.Conn.Query

  def pagination(assigns) do
    ~H"""
    <div class={@class}>
      <nav class="flex justify-between items-center px-4 mb-5 w-full">
        <%= if @meta.total_pages > 1 do %>
          <div class="flex flex-1 -mt-px w-0">
            <%= if @meta.has_previous_page? do %>
              <%= live_patch to: build_query(@meta.previous_page, @params), class: "inline-flex items-center pt-4 pr-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
                <Heroicons.Solid.arrow_narrow_left class="mr-3 w-5 h-5 text-gray-400" />
              <% end %>
            <% end %>
          </div>
          <div class="flex lg:-mt-px">
            <%= if max(1, @meta.current_page - 2) != 1 do %>
              <%= live_patch("1", to: build_query(1, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700 ") %>

              <%= if @meta.current_page - 2 > 2 do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                  ...
                </span>
              <% end %>
            <% end %>

            <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
              <%= if @meta.current_page == page do %>
                <%= live_patch("#{page}", to: build_query(page, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-secondary") %>
              <% else %>
                <%= live_patch("#{page}", to: build_query(page, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
              <% end %>
            <% end %>

            <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
              <%= if @meta.current_page + 3 < @meta.total_pages do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500">
                  ...
                </span>
              <% end %>
              <%= live_patch("#{@meta.total_pages}", to: build_query(@meta.total_pages, @params), class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700") %>
            <% end %>
          </div>
          <div class="flex flex-1 justify-end -mt-px w-0">
            <%= if @meta.has_next_page? do %>
              <%= live_patch to: build_query(@meta.next_page, @params), class: "inline-flex items-center pt-4 pl-1 text-sm font-medium text-gray-500 hover:text-gray-700" do %>
                <Heroicons.Solid.arrow_narrow_right class="ml-3 w-5 h-5 text-gray-400" />
              <% end %>
            <% end %>
          </div>
        <% end %>
      </nav>
    </div>
    """
  end

  defp build_query(page, params) do
    query = Map.put(params, "page", page)

    "?#{Query.encode(query)}"
  end
end
