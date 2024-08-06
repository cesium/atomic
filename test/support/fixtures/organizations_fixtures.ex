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
        name: "SN",
        long_name: "some name"
      })
      |> Atomic.Organizations.create_organization()

    organization
  end
end
