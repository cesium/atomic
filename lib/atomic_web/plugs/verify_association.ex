defmodule AtomicWeb.Plugs.VerifyAssociation do
  @moduledoc """
  This plug is used to confirm if the object being accessed has an association with the organization in the connection parameters.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, fun) do
    case conn.params["id"] do
      id when is_binary(id) ->
        case fun.(id) do
          nil ->
            conn
            |> send_resp(:not_found, "")
            |> halt()

          entity ->
            verify_association(entity, conn)
        end

      _ ->
        conn
    end
  end

  defp verify_association(entity, conn) do
    if has_relation?(entity, conn.params["organization_id"]) do
      conn
    else
      conn
      |> send_resp(:not_found, "")
      |> halt()
    end
  end

  defp has_relation?(_, organization_id) when is_nil(organization_id), do: false

  defp has_relation?(entity, organization_id) do
    entity.organization_id == organization_id
  end
end
