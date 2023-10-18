defmodule Atomic.Exporter do
  @moduledoc """

  Utilities for tabular data exporting.
  Supports csv and xlsx formats.

  """

  alias Elixlsx.{Sheet, Workbook}

  @doc """
  Builds a csv formatted string with the data in the entities list.

  ## Examples

    iex> entities_to_csv([%{name: "John Doe", age: 23}, %{name: "Jane Doe", age: 25}], [[:name], [:age]])
    "name,age\nJohn Doe,23\nJane Doe,25"

    iex> entities_to_csv([%{name: "John Doe", age: 23, dog: %{name: "Cooper", breed: "Beagle"}}], [[:name], [:dog, :breed]])
    "name,breed\nJohn Doe,Beagle"
  """
  def entities_to_csv(entities, columns) do
    data =
      ([Enum.map_join(columns, ",", fn col -> List.last(col) end)] ++
         (entities
          |> Enum.map(fn entity ->
            extract_entity_values(entity, columns)
            |> Enum.join(",")
          end)))
      |> Enum.intersperse("\n")
      |> to_string()

    data
  end

  @doc """
  Builds an xlsx workbook containing a sheet with the data in the entities list.

  ## Examples

    iex> entities_to_xlsx_workbook([%{name: "John Doe", age: 23}, %{name: "Jane Doe", age: 25}], [[[:name], 20], [[:age], 10]], [], "People")
    %Elixlsx.Workbook{
      sheets: [
        %Elixlsx.Sheet{
          name: "People",
          rows: [[["Name"], ["Age"]], ["John Doe", 23], ["Jane Doe", 25]],
          col_widths: %{1 => 20, 2 => 10},
          row_heights: %{},
          group_cols: [],
          group_rows: [],
          merge_cells: [],
          pane_freeze: {1, 2},
          show_grid_lines: true
        }
      ],
      datetime: nil
    }
  """
  def entities_to_xlsx_workbook(entities, columns, header_styles, sheet_name) do
    paths = columns |> Enum.map(fn column -> List.first(column) end)
    sizes = columns |> Enum.map(fn column -> List.last(column) end)

    column_widths =
      1..length(sizes)
      |> Enum.zip(sizes)
      |> Map.new()

    sheet =
      %Sheet{
        name: sheet_name,
        rows:
          [
            Enum.map(paths, fn column ->
              [column |> List.last() |> format_atom() | header_styles]
            end)
          ] ++
            Enum.map(entities, fn entity ->
              Enum.map(extract_entity_values(entity, paths), &value_to_excel/1)
            end)
      }
      |> Sheet.set_pane_freeze(1, length(columns))
      |> Map.replace(:col_widths, column_widths)

    %Workbook{sheets: [sheet]}
  end

  defp extract_entity_values(entity, columns) do
    Enum.map(columns, fn col ->
      List.foldl(col, entity, fn key, object -> Map.get(object, key) end)
    end)
  end

  defp format_atom(key) do
    key
    |> to_string()
    |> String.split("_")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  defp value_to_excel(%NaiveDateTime{} = date) do
    [datetime_to_excel(date), datetime: true]
  end

  defp value_to_excel(value) do
    value
  end

  defp datetime_to_excel(date) do
    {{date.year, date.month, date.day}, {date.hour, date.minute, date.second}}
  end
end
