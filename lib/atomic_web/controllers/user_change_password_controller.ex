defmodule AtomicWeb.UserChangePasswordController do
  use AtomicWeb, :controller

  alias Atomic.Accounts
  alias AtomicWeb.UserAuth

  plug :assign_password_changeset

  def edit(conn, _params) do
    render(conn, "edit.html", error_message: nil)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, user_params["current_password"], user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, ~p"/users/change_password")
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, error_message: "Password didn't change.")
    end
  end

  defp assign_password_changeset(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:changeset, Accounts.change_user_password(user))
  end
end
