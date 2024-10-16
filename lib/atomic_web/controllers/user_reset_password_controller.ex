defmodule AtomicWeb.UserResetPasswordController do
  use AtomicWeb, :controller

  alias Atomic.Accounts

  plug :get_user_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => %{"input" => input}}) do
    user = Accounts.get_user_by_email(input) || Accounts.get_user_by_slug(input)

    if user do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email or username is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: ~p"/users/log_in")
  end

  def edit(conn, _params) do
    render(conn, "edit.html",
      changeset: Accounts.change_user_password(conn.assigns.user),
      error_message: nil
    )
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def update(conn, %{"user" => user_params}) do
    case Accounts.reset_user_password(conn.assigns.user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password changed successfully.")
        |> redirect(to: ~p"/users/log_in")

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, error_message: nil)
    end
  end

  defp get_user_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if user = Accounts.get_user_by_reset_password_token(token) do
      conn |> assign(:user, user) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/404")
    end
  end
end
