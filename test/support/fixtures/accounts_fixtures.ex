defmodule Atomic.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Accounts` context.
  """

  alias Atomic.OrganizationsFixtures
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "password1234"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      default_organization_id: OrganizationsFixtures.organization_fixture().id
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Atomic.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
