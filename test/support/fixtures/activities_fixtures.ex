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

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        finish: ~N[2022-10-22 20:00:00],
        start: ~N[2022-10-22 20:00:00]
      })
      |> Atomic.Activities.create_session()

    session
  end

  @doc """
  Generate a enrollment.
  """
  def enrollment_fixture(attrs \\ %{}) do
    {:ok, enrollment} =
      attrs
      |> Enum.into(%{})
      |> Atomic.Activities.create_enrollment()

    enrollment
  end
end
