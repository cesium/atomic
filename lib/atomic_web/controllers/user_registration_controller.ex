defmodule AtomicWeb.UserRegistrationController do
  use AtomicWeb, :controller

  alias Atomic.Accounts
  alias Atomic.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn =
      conn
      |> assign(:roles, ~w(admin student)a)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    if user_params["password"] == user_params["password_confirmation"] do
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &Routes.user_confirmation_url(conn, :edit, &1)
            )

          conn
          |> put_flash(:info, "Registered successfully. Check your email inbox before continuing")
          |> render("new.html", changeset: Accounts.change_user_registration(user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Passwords don't match.")
      |> render("new.html",
        changeset: Accounts.change_user_registration(%User{email: user_params["email"]})
      )
    end
  end
end
