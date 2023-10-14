defmodule AtomicWeb.DataExportController do
  use AtomicWeb, :controller

  alias Atomic.Organizations
  alias Elixlsx.{Sheet, Workbook}

  # Generic excel heder styling
  @header_styles [
    align_horizontal: :center,
    bold: true,
    size: 12,
    color: "#ffffff",
    bg_color: "#ff9900"
  ]

  # Membership columns used on data generation, the column width sizes are only used on the excel export
  @membership_export_columns [
    [[:number], 10],
    [[:user, :name], 40],
    [[:user, :phone_number], 20],
    [[:user, :email], 30],
    [[:user, :inserted_at], 30]
  ]

  @doc """
  Returns an organization's memberships as a CSV file.
  """
  def export_memberships_csv(conn, %{"organization_id" => organization_id}) do
    case write_memberships_csv(organization_id) do
      {:ok, data} ->
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"memberships.csv\"")
        |> put_root_layout(false)
        |> send_resp(200, data)
    end
  end

  @doc """
  Returns an organization's memberships as a formatted
  XLSX workbook.

  The generated workbook only contains one sheet displaying
  the organization's memberships.
  In the occurence of an error when writing the document
  to memory it returns a 500 response with an explanation.
  """
  def export_memberships_xlsx(conn, %{"organization_id" => organization_id}) do
    case write_memberships_xlsx(organization_id) do
      {:ok, data} ->
        conn
        |> put_resp_content_type("text/xlsx")
        |> put_resp_header("content-disposition", "attachment; filename=\"memberships.xlsx\"")
        |> put_root_layout(false)
        |> send_resp(200, data)

      {:error, reason} ->
        conn |> send_resp(500, "Internal Server Error: #{reason}")
    end
  end

  defp write_memberships_csv(organization_id) do
    Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    |> entities_to_csv(
      @membership_export_columns
      |> Enum.map(fn column -> List.first(column) end)
    )
  end

  defp write_memberships_xlsx(organization_id) do
    memberships = Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    organization = Organizations.get_organization!(organization_id)

    case entities_to_xlsx_workbook(
           memberships,
           @membership_export_columns,
           @header_styles,
           "#{organization.name}'s Memberships"
         )
         |> Elixlsx.write_to_memory("memberships-#{organization_id}.xlsx") do
      {:ok, {_, data}} -> {:ok, data}
      {:error, reason} -> {:error, to_string(reason)}
    end
  end

  defp entities_to_xlsx_workbook(entities, columns, header_styles, sheet_name) do
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
              Enum.map(paths, fn col ->
                List.foldl(col, entity, fn key, object -> Map.get(object, key) end)
                |> value_to_excel()
              end)
            end)
      }
      |> Sheet.set_pane_freeze(1, length(columns))
      |> Map.replace(:col_widths, column_widths)

    %Workbook{sheets: [sheet]}
  end

  defp entities_to_csv(entities, columns) do
    data =
      ([Enum.map(columns, fn col -> List.last(col) end) |> Enum.join(",")] ++
         (entities
          |> Enum.map(fn entity ->
            Enum.map(columns, fn col ->
              List.foldl(col, entity, fn key, object -> Map.get(object, key) end)
            end)
            |> Enum.join(",")
          end)))
      |> Enum.intersperse("\n")
      |> to_string()

    {:ok, data}
  end

  defp format_atom(key) do
    key
    |> to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp value_to_excel(date = %NaiveDateTime{}) do
    [datetime_to_excel(date), datetime: true]
  end

  defp value_to_excel(value) do
    value
  end

  defp datetime_to_excel(date) do
    {{date.year, date.month, date.day}, {date.hour, date.minute, date.second}}
  end
end
