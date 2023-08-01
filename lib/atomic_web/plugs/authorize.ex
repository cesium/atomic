defmodule AtomicWeb.Plugs.Authorize do
  @moduledoc false
  import Plug.Conn

  alias Atomic.Organizations

  def init(opts), do: opts

  def call(conn, minimum_authorized_role) do
    if authorized?(conn, minimum_authorized_role) do
      conn
    else
      conn
      |> send_resp(:not_found, "")
      |> halt()
    end
  end

  defp authorized?(conn, minimum_authorized_role) do
    organization_id = get_organization_id(conn)

    case {organization_id, conn.assigns.current_user} do
      {nil, _} ->
        false

      {id, user} ->
        user_authorized?(user, id, minimum_authorized_role)
    end
  end

  defp get_organization_id(conn) do
    case conn.params["organization_id"] do
      organization_id when is_binary(organization_id) ->
        organization_id

      _ ->
        nil
    end
  end

  defp user_authorized?(user, organization_id, minimum_authorized_role) do
    user_organizations = Enum.map(user.organizations, & &1.id)
    role = Organizations.get_role(user.id, organization_id)
    allowed_roles = Organizations.roles_bigger_than_or_equal(minimum_authorized_role)

    organization_id in user_organizations && role in allowed_roles
  end
end
