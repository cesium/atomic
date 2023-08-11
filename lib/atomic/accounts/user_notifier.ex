defmodule Atomic.Accounts.UserNotifier do
  @moduledoc false
  import Swoosh.Email

  alias Atomic.Mailer

  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  defp base_email(to: email) do
    new()
    |> to(email)
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
  end

  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
    |> to(email)
  end

  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Atomic", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    email =
      base_email(to: user.email)
      |> subject("Confirm your Account")
      |> assign(:user, user)
      |> assign(:url, url)
      |> render_body("user_confirmation.txt")

    case Mailer.deliver(email) do
      {:ok, _term} -> {:ok, email}
      {:error, ch} -> {:error, ch}
    end
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    email =
      base_email(to: user.email)
      |> subject("Reset Password Instructions")
      |> assign(:user, user)
      |> assign(:url, url)
      |> render_body("user_reset_password.txt")

    case Mailer.deliver(email) do
      {:ok, _term} -> {:ok, email}
      {:error, ch} -> {:error, ch}
    end
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
