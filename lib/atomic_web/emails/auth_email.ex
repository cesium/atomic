defmodule AtomicWeb.Emails.AuthEmails do
  @moduledoc """
  A module to build auth related emails.
  """

  use Phoenix.Swoosh, view: AtomicWeb.EmailView, layout: {AtomicWeb.LayoutView, :email}

  def reset_password_email(id, to: email) do
    frontend_url = Application.fetch_env!(:store, AtomicWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] Instruções para repor a password")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/users/reset_password/" <> id)
  end

  def confirm_account_email(id, to: email) do
    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] Confirmação da conta")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, id)
    |> assign(:user, Atomic.Accounts.get_user_by_email(email))
    |> render_body("confirm_account.html")
  end
end
