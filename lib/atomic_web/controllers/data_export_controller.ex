defmodule AtomicWeb.DataExportController do
  use AtomicWeb, :controller

  alias Atomic.Organizations
  alias Elixlsx.{Sheet, Workbook}

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

  defp write_memberships_xlsx(organization_id) do
    memberships = Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    organization = Organizations.get_organization!(organization_id)

    columns = [
      [:number],
      [:user, :name],
      [:user, :phone_number],
      [:user, :email],
      # [:user, :inserted_at]
    ]

    header_styles = [
      align_horizontal: :center,
      bold: true,
      size: 12,
      color: "#ffffff",
      bg_color: "#ff9900"
    ]

    memberships_sheet =
      %Sheet{
        name: "#{organization.name}'s Memberships",
        rows:
          [
            Enum.map(columns, fn column ->
              [column |> List.last() |> format_atom() | header_styles]
            end)
          ] ++
            Enum.map(memberships, fn membership ->
              Enum.map(columns, fn col ->
                List.foldl(col, membership, fn key, entity -> Map.get(entity, key) end)
              end)
            end)
      }
      |> Sheet.set_pane_freeze(1, 5)
      |> Sheet.set_col_width("A", 10)
      |> Sheet.set_col_width("B", 40)
      |> Sheet.set_col_width("C", 20)
      |> Sheet.set_col_width("D", 30)
      |> Sheet.set_col_width("E", 30)

    case %Workbook{sheets: [memberships_sheet]}
         |> Elixlsx.write_to_memory("memberships-#{organization_id}.xlsx") do
      {:ok, {_, data}} -> {:ok, data}
      {:error, reason} -> {:error, to_string(reason)}
    end
  end

  defp write_memberships_csv(organization_id) do
    columns = [
      [:number],
      [:user, :name],
      [:user, :phone_number],
      [:user, :email],
      [:user, :inserted_at]
    ]

    data =
      ([Enum.map(columns, fn col -> List.last(col) end) |> Enum.join(",")] ++
         (Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
          |> Enum.map(fn membership ->
            Enum.map(columns, fn col ->
              List.foldl(col, membership, fn key, entity -> Map.get(entity, key) end)
            end)
            |> Enum.join(",")
          end)))
      |> Enum.intersperse("\n")
      |> to_string()

    {:ok, data}
  end

  defp format_atom(key) do
    IO.inspect(key)
    key
    |> to_string()
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp datetime_to_excel(date) do
    {{date.year, date.month, date.day}, {date.hour, date.minute, date.second}}
  end
end
