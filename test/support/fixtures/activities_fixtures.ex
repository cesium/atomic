defmodule Atomic.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Activities` context.
  """

  alias Atomic.OrganizationsFixtures

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        maximum_entries: 42,
        minimum_entries: 0,
        finish: ~N[2022-10-22 20:00:00],
        start: ~N[2022-10-22 20:00:00],
        organization_id: OrganizationsFixtures.organization_fixture().id
      })
      |> Atomic.Activities.create_activity_with_post()

    activity
  end
end
