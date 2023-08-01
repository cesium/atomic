defmodule Atomic.PartnershipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Partnerships` context.
  """

  alias Atomic.OrganizationsFixtures

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    {:ok, partner} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        organization_id: OrganizationsFixtures.organization_fixture().id
      })
      |> Atomic.Partnerships.create_partner()

    partner
  end
end
