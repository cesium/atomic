defmodule Atomic.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        description: "some description",
        maximum_entries: 42,
        minimum_entries: 42,
        title: "some title"
      })
      |> Atomic.Activities.create_activity()

    activity
  end
end
