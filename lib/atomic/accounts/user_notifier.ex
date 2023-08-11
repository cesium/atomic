defmodule Atomic.Accounts.UserNotifier do
  @moduledoc false
  import Swoosh.Email

  alias Atomic.Mailer

  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
    |> to(email)
  end

  defp deliver(a, b, c) do
    {:ok, ""}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    base_email(to: user.email)
    |> subject("Reset Password Instructions")
    |> assign(:user, user)
    |> assign(:url, url)
    |> render_body("user_reset_password.txt")
    |> Mailer.deliver()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
