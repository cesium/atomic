defmodule AtomicWeb.Auth.AllowedRoles do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    if conn.assigns.current_user.role in opts do
      conn
    else
      conn
      |> send_resp(:not_found, "")
      |> halt()
    end
  end
end
