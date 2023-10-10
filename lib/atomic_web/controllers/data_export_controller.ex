defmodule AtomicWeb.DataExportController do
  use AtomicWeb, :controller

  alias Atomic.Organizations
  alias Elixlsx.{Sheet, Workbook}

  def export_memberships_csv(conn, %{"organization_id" => organization_id}) do
    data = write_memberships_csv(organization_id)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"memberships.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, data)
  end

  def export_memberships_xlsx(conn, %{"organization_id" => organization_id}) do
    data = write_memberships_xlsx(organization_id)

    case data do
      :error ->
        conn |> send_resp(500, "Internal Server Error")

      _ ->
        conn
        |> put_resp_content_type("text/xlsx")
        |> put_resp_header("content-disposition", "attachment; filename=\"memberships.xlsx\"")
        |> put_root_layout(false)
        |> send_resp(200, data)
    end
  end

  defp write_memberships_xlsx(organization_id) do
    memberships = Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    organization = Organizations.get_organization!(organization_id)

    column_names = ["Name", "Phone Number", "Email", "Created At"]

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
          [Enum.map(column_names, fn column -> [column | header_styles] end)] ++
            Enum.map(memberships, fn membership ->
              [
                membership.user.name,
                membership.user.phone_number,
                membership.user.email,
                [
                  datetime_to_excel(membership.user.inserted_at),
                  datetime: true,
                  align_horizontal: :left
                ]
              ]
            end)
      }
      |> Sheet.set_pane_freeze(1, 4)
      |> Sheet.set_col_width("A", 40)
      |> Sheet.set_col_width("B", 20)
      |> Sheet.set_col_width("C", 30)
      |> Sheet.set_col_width("D", 30)

    case %Workbook{sheets: [memberships_sheet]}
         |> Elixlsx.write_to_memory("memberships-#{organization_id}.xlsx") do
      {:ok, {_, data}} -> data
      {:error, _} -> :error
    end
  end

  defp write_memberships_csv(organization_id) do
    Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    |> Enum.map(fn membership ->
      [
        membership.user.name,
        membership.user.phone_number,
        membership.user.email,
        membership.user.inserted_at
      ]
      |> Enum.join(",")
    end)
    |> List.insert_at(0, "name,phone_number,email,created_at")
    |> Enum.intersperse("\n")
    |> to_string()
  end

  defp datetime_to_excel(date) do
    {{date.year, date.month, date.day}, {date.hour, date.minute, date.second}}
  end
end
