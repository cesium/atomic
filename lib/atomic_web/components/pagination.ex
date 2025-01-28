defmodule AtomicWeb.Components.Pagination do
  @moduledoc false
  use AtomicWeb, :component

  alias Plug.Conn.Query

  import AtomicWeb.Components.Helpers

  attr :id, :string, default: "pagination", required: false
  attr :items, :list, required: true
  attr :meta, :map, required: true
  attr :params, :map, required: true
  attr :class, :string, default: "", required: false

  def pagination(assigns) do
    ~H"""
    <div id={@id} class={@class}>
      <nav class="mb-5 flex w-full items-center justify-between px-4">
        <%= if @meta.total_pages > 1 do %>
          <div class="-mt-px flex w-0 flex-1">
            <%= if @meta.has_previous_page? do %>
              <.link patch={build_query(@meta.previous_page, @meta, @params)} class="inline-flex items-center pt-4 pr-1 text-sm font-medium text-zinc-500 hover:text-zinc-700">
                <.icon name="hero-arrow-long-left-solid" class="size-5 mr-3 text-zinc-400" />
              </.link>
            <% end %>
          </div>
          <div class="flex select-none lg:-mt-px">
            <%= if max(1, @meta.current_page - 2) != 1 do %>
              <.link patch={build_query(1, @meta, @params)} class="inline-flex items-center px-4 pt-4 text-sm font-medium text-zinc-500 hover:text-zinc-700">1</.link>
              <%= if @meta.current_page - 2 > 2 do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-zinc-500">
                  ...
                </span>
              <% end %>
            <% end %>
            <%= for page <- max(1, @meta.current_page - 2)..max(min(@meta.total_pages, @meta.current_page + 2), 1) do %>
              <%= if @meta.current_page == page do %>
                <.link patch={build_query(page, @meta, @params)} class="text-secondary inline-flex items-center px-4 pt-4 text-sm font-medium"><%= page %></.link>
              <% else %>
                <.link patch={build_query(page, @meta, @params)} class="inline-flex items-center px-4 pt-4 text-sm font-medium text-zinc-500 hover:text-zinc-700"><%= page %></.link>
              <% end %>
            <% end %>
            <%= if min(@meta.total_pages, @meta.current_page + 2) != @meta.total_pages do %>
              <%= if @meta.current_page + 3 < @meta.total_pages do %>
                <span class="inline-flex items-center px-4 pt-4 text-sm font-medium text-zinc-500">
                  ...
                </span>
              <% end %>
              <.link patch={build_query(@meta.total_pages, @meta, @params)} class="inline-flex items-center px-4 pt-4 text-sm font-medium text-zinc-500 hover:text-zinc-700"><%= @meta.total_pages %></.link>
            <% end %>
          </div>
          <div class="-mt-px flex w-0 flex-1 justify-end">
            <%= if @meta.has_next_page? do %>
              <.link patch={build_query(@meta.next_page, @meta, @params)} class="inline-flex items-center pt-4 pl-1 text-sm font-medium text-zinc-500 hover:text-zinc-700">
                <.icon name="hero-arrow-long-right-solid" class="size-5 ml-3 text-zinc-400" />
              </.link>
            <% end %>
          </div>
        <% end %>
      </nav>
    </div>
    """
  end

  defp build_query(page, meta, params) do
    flop_params = meta.flop |> Flop.set_page(page) |> to_query(for: meta.schema) |> Query.encode()

    if params["tab"] do
      "?tab=#{params["tab"]}&#{flop_params}"
    else
      "?#{flop_params}"
    end
  end
end
