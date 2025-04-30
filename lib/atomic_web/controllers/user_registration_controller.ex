defmodule AtomicWeb.UserRegistrationController do
  use AtomicWeb, :controller

  alias Atomic.Accounts

  def create(conn, %{"user" => user_params}) do
    if user_params["password"] == user_params["confirm_password"] do
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &url(~p"/users/confirm/#{&1}")
            )

          conn
          |> put_flash(
            :info,
            "Registered successfully. Check your email inbox before continuing."
          )
          |> redirect(to: ~p"/users/register")

        {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_flash(:error, "Unable to register. This email may already be registered.")
          |> redirect(to: ~p"/users/register")
      end
    else
      conn
      |> put_flash(:error, "Passwords don't match.")
      |> redirect(to: ~p"/users/register")
    end
  end
end
