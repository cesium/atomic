defmodule Atomic.ActivitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Activites` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        capacity: 42,
        date: ~U[2022-10-19 15:58:00Z],
        description: "some description",
        location: "some location",
        title: "some title"
      })
      |> Atomic.Activites.create_activity()

    activity
  end
end
