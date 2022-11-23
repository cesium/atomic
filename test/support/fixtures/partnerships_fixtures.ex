defmodule Atomic.PartnershipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Partnerships` context.
  """

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    {:ok, partner} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Atomic.Partnerships.create_partner()

    partner
  end
end
