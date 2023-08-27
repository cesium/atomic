defmodule AtomicWeb.Components.Table do
  @moduledoc false
  use AtomicWeb, :component

  alias Plug.Conn.Query

  import AtomicWeb.Components.Helpers

  def table(assigns) do
    ~H"""
    <table class="min-w-full divide-y divide-gray-300 overflow-auto border-collapse">
      <thead>
        <tr class="bg-gray-50 select-none">
          <%= for col <- @col do %>
            <.header_column field={col[:field]} label={col[:label]} filter={if Map.has_key?(assigns, :filter), do: @filter, else: nil} meta={@meta} />
          <% end %>
        </tr>
        <tbody>
          <%= for item <- @items do %>
            <tr class="leading-3" style="height: 30px;">
              <%= for col <- @col do %>
                <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 border-b-[1px] border-r-[1px] sm:pl-6">
                  <%= render_slot(col, item) %>
                </td>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </thead>
    </table>
    """
  end

  defp header_column(assigns) do
    index = order_index(assigns.meta.flop, assigns.field)
    direction = order_direction(assigns.meta.flop.order_directions, index)

    ~H"""
    <th class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6 border-r-[1px]" scope="col">
      <%= if is_sortable?(@field, @meta.schema) && is_filterable?(@field, @meta.schema) && should_filter(@field, @filter) do %>
        <div class="flex justify-between">
          <%= live_patch(to: build_sorting_query(@field, @meta), class: "w-full mr-2") do %>
            <div class="flex justify-between">
              <span><%= @label %></span>
              <.sorting_arrow direction={direction} />
            </div>
          <% end %>
          <.filter_input field={@field} meta={@meta} filter={extract_filter_type(@field, @filter)} />
        </div>
      <% else %>
        <%= if is_sortable?(@field, @meta.schema) do %>
          <%= live_patch(to: build_sorting_query(@field, @meta)) do %>
            <div class="flex justify-between">
              <span><%= @label %></span>
              <.sorting_arrow direction={direction} />
            </div>
          <% end %>
        <% else %>
          <%= if is_filterable?(@field, @meta.schema) && should_filter(@field, @filter) do %>
            <div class="flex justify-between">
              <span><%= @label %></span>
              <.filter_input field={@field} meta={@meta} filter={extract_filter_type(@field, @filter)} />
            </div>
          <% else %>
            <span><%= @label %></span>
          <% end %>
        <% end %>
      <% end %>
    </th>
    """
  end

  defp filter_input(assigns) do
    ~H"""
    <div x-data="{ open: false }">
      <span @click="open = ! open" class="flex justify-center rounded p-1 w-5 h-5 self-center hover:bg-gray-200 cursor-pointer">
        <span class="self-center">
          <Heroicons.Solid.search class="align-center w-4 h-4" />
        </span>
      </span>
      <div x-show="open" class="absolute p-2 -translate-x-3/4">
        <.form let={f} for={@meta}>
          <Flop.Phoenix.filter_fields let={entry} form={f} fields={@filter} input_opts={[class: "pl-0 appearance-none text-zinc-900 placeholder-zinc-500 sm:text-sm border-none w-full focus:outline-none focus:ring-transparent"]}>
            <div class="flex bg-white w-full relative appearance-none rounded-lg border border-zinc-300 px-3 py- text-zinc-900 placeholder-zinc-500 focus-within:z-10 focus-within:border-zinc-400 focus-within:ring-zinc-400 focus-within:outline-none sm:text-sm">
              <%= entry.input %>
            </div>
          </Flop.Phoenix.filter_fields>
        </.form>
      </div>
    </div>
    """
  end

  defp sorting_arrow(assigns) do
    ~H"""
    <%= if @direction in [:asc, :asc_nulls_first, :asc_nulls_last] do %>
      <span class="self-center">
        <Icons.FontAwesome.Solid.sort_up class="w-3 h-3" />
      </span>
    <% end %>
    <%= if @direction in [:desc, :desc_nulls_first, :desc_nulls_last] do %>
      <span class="self-center">
        <Icons.FontAwesome.Solid.sort_down class="w-3 h-3" />
      </span>
    <% end %>
    <%= if is_nil(@direction) do %>
      <span class="self-center">
        <Icons.FontAwesome.Solid.sort class="w-3 h-3" />
      </span>
    <% end %>
    """
  end

  defp extract_filter_type(field, filters) do
    Keyword.new([{field, filters[field]}])
  end

  defp should_filter(_, nil), do: false

  defp should_filter(field, filters) do
    Keyword.has_key?(filters, field)
  end

  defp build_sorting_query(field, meta) do
    meta.flop
    |> Flop.push_order(field)
    |> to_query(for: meta.schema)
    |> Query.encode()
    |> then(&"?#{&1}")
  end

  defp order_index(%Flop{order_by: nil}, _), do: nil

  defp order_index(%Flop{order_by: order_by}, field) do
    Enum.find_index(order_by, &(&1 == field))
  end

  defp order_direction(_, nil), do: nil
  defp order_direction(nil, _), do: :asc
  defp order_direction(directions, index), do: Enum.at(directions, index)

  defp is_sortable?(nil, _), do: false
  defp is_sortable?(_, nil), do: true

  defp is_sortable?(field, module) do
    field in (module |> struct() |> Flop.Schema.sortable())
  end

  defp is_filterable?(nil, _), do: false
  defp is_filterable?(_, nil), do: true

  defp is_filterable?(field, module) do
    field in (module |> struct() |> Flop.Schema.filterable())
  end
end
