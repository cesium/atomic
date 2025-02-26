defmodule AtomicWeb.OAuth do
  use AtomicWeb, :controller
  plug Ueberauth

  import Plug.Conn

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # You will have to implement this function that inserts into the database
    # user = MyApp.Accounts.create_user_from_ueberauth!(auth)

    # If you are using mix phx.gen.auth, you can use it to login
    # MyAppWeb.UserAuth.log_in_user(conn, user)

    IO.inspect(auth)

    conn
    |> renew_session()
    # |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
