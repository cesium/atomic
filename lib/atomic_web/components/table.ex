defmodule AtomicWeb.Components.Table do
  @moduledoc false
  use AtomicWeb, :component

  alias Plug.Conn.Query

  import AtomicWeb.Components.Helpers

  attr :id, :string, default: "table", required: false
  attr :items, :list, required: true
  attr :meta, :map, required: true
  attr :filter, :list, required: true

  slot :col do
    attr :label, :string, required: false
    attr :field, :atom, required: false
  end

  def table(assigns) do
    ~H"""
    <table id={@id} class="min-w-full border-collapse divide-y divide-zinc-300 overflow-auto">
      <thead>
        <tr class="select-none bg-zinc-50">
          <%= for col <- @col do %>
            <.header_column field={col[:field]} label={col[:label]} filter={if Map.has_key?(assigns, :filter), do: @filter, else: nil} meta={@meta} />
          <% end %>
        </tr>
        <tbody>
          <%= for item <- @items do %>
            <tr class="leading-3" style="height: 30px;">
              <%= for col <- @col do %>
                <td class="border-b-[1px] border-r-[1px] whitespace-nowrap p-4 text-sm text-zinc-500">
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

    assigns =
      assign(assigns, :direction, order_direction(assigns.meta.flop.order_directions, index))

    ~H"""
    <th class="border-r-[1px] px-4 py-3.5 text-left text-sm font-semibold text-zinc-900" scope="col">
      <%= if sortable?(@field, @meta.schema) && filterable?(@field, @meta.schema) && should_filter(@field, @filter) do %>
        <div class="flex justify-between">
          <.link patch={build_sorting_query(@field, @meta)} class="mr-2 w-full">
            <div class="flex justify-between">
              <span><%= @label %></span>
              <.sorting_arrow direction={@direction} />
            </div>
          </.link>
          <.filter_input field={@field} meta={@meta} filter={extract_filter_type(@field, @filter)} />
        </div>
      <% else %>
        <%= if sortable?(@field, @meta.schema) do %>
          <.link patch={build_sorting_query(@field, @meta)}>
            <div class="flex justify-between">
              <span><%= @label %></span>
              <.sorting_arrow direction={@direction} />
            </div>
          </.link>
        <% else %>
          <%= if filterable?(@field, @meta.schema) && should_filter(@field, @filter) do %>
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
      <span @click="open = ! open" class="flex size-5 cursor-pointer justify-center self-center rounded p-1 hover:bg-zinc-200">
        <span class="self-center">
          <.icon name="hero-magnifying-glass-solid" class="align-center size-4" />
        </span>
      </span>
      <div x-show="open" class="absolute -translate-x-3/4 p-2">
        <.form :let={f} for={@meta}>
          <Flop.Phoenix.filter_fields :let={i} form={f} fields={@filter}>
            <.input id={i.field.id} name={i.field.name} value={i.field.value} field={i.field} label={i.label} type={i.type} rest={i.rest} />
          </Flop.Phoenix.filter_fields>
        </.form>
      </div>
    </div>
    """
  end

  defp input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400"
        ]}
        {@rest}
      />
    </div>
    """
  end

  defp sorting_arrow(assigns) do
    ~H"""
    <%= if @direction in [:asc, :asc_nulls_first, :asc_nulls_last] do %>
      <span class="self-center">
        <.icon name="hero-chevron-up" class="size-3" />
      </span>
    <% end %>
    <%= if @direction in [:desc, :desc_nulls_first, :desc_nulls_last] do %>
      <span class="self-center">
        <.icon name="hero-chevron-down" class="size-3" />
      </span>
    <% end %>
    <%= if is_nil(@direction) do %>
      <span class="self-center">
        <.icon name="hero-chevron-up-down" class="size-3" />
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

  defp sortable?(nil, _), do: false
  defp sortable?(_, nil), do: true

  defp sortable?(field, module) do
    field in (module |> struct() |> Flop.Schema.sortable())
  end

  defp filterable?(nil, _), do: false
  defp filterable?(_, nil), do: true

  defp filterable?(field, module) do
    field in (module |> struct() |> Flop.Schema.filterable())
  end
end
