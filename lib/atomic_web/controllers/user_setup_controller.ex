defmodule AtomicWeb.UserSetupController do
  use AtomicWeb, :controller

  alias Atomic.Accounts

  @forbidden_characters "!#$%&'*+-/=?^`{|}~"

  def edit(conn, _params) do
    user = conn.assigns.current_user

    recommended_handle =
      String.replace(
        Accounts.extract_email_address_local_part(user.email),
        ~r/[#{@forbidden_characters}]+/,
        ""
      )

    changeset = Accounts.change_user_setup(Map.put(user, :handle, recommended_handle))

    render(conn, "edit.html", changeset: changeset)
  end

  def finish(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.finish_user_setup(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account setup complete.")
        |> redirect(to: "/organizations")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
