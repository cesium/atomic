defmodule Atomic.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Organizations` context.
  """

  @doc """
  Generate an organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Atomic.Organizations.create_organization()

    organization
  end

  @doc """
  Generate an membership
  """
  def membership_fixture(attrs \\ %{}) do
    {:ok, organization} =
      %{}
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Atomic.Organizations.create_organization()

    {:ok, user} =
      %{}
      |> Enum.into(%{
        email: "test@mail.pt",
        password: "password1234",
        role: :student
      })
      |> Atomic.Accounts.register_user()

    {:ok, membership} =
      attrs
      |> Enum.into(%{
        role: :member,
        created_by_id: user.id,
        user_id: user.id,
        organization_id: organization.id
      })
      |> Atomic.Organizations.create_membership()

    membership
  end
end
