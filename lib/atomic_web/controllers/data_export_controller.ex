defmodule AtomicWeb.DataExportController do
  use AtomicWeb, :controller

  alias Atomic.Exporter
  alias Atomic.Organizations
  alias Atomic.Organizations.Membership

  # Generic excel header styling
  @header_styles [
    align_horizontal: :center,
    bold: true,
    size: 12,
    color: "#ffffff",
    bg_color: "#ff9900"
  ]

  @doc """
  Returns an organization's memberships as a csv file.
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
  xlsx workbook.

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
    {:ok,
     Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
     |> Exporter.entities_to_csv(
       Membership.export_fields()
       |> Enum.map(fn column -> List.first(column) end)
     )}
  end

  defp write_memberships_xlsx(organization_id) do
    memberships = Organizations.list_memberships(%{"organization_id" => organization_id}, [:user])
    organization = Organizations.get_organization!(organization_id)

    case Exporter.entities_to_xlsx_workbook(
           memberships,
           Membership.export_fields(),
           @header_styles,
           "#{organization.name}'s Memberships"
         )
         |> Elixlsx.write_to_memory("memberships-#{organization_id}.xlsx") do
      {:ok, {_, data}} -> {:ok, data}
      {:error, reason} -> {:error, to_string(reason)}
    end
  end
end
