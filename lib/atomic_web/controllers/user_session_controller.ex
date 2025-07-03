defmodule AtomicWeb.UserSessionController do
  use AtomicWeb, :controller

  alias Atomic.Accounts
  alias AtomicWeb.UserAuth

  def new(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, %{user: user, attendee: _}} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        conn
        |> UserAuth.log_in_user(user, user_params)
        |> put_flash(:success, "Registered successfully")
        |> redirect(to: ~p"/users/setup")

      {:error, _, %Ecto.Changeset{} = _changeset, _} ->
        conn
        |> put_flash(:error, "Unable to register. This email may already be registered.")
        |> redirect(to: ~p"/users/register")
    end
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params
    user = Accounts.get_user_by_email_and_password(email, password)

    if user do
      if is_nil(user.confirmed_at) do
        conn
        |> put_flash(:error, "You need to confirm your email address.")
        |> redirect(to: ~p"/users/log_in")
      else
        UserAuth.log_in_user(conn, user, user_params)
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password.")
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
