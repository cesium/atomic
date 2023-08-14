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
        maximum_entries: 42,
        minimum_entries: 42,
        finish: ~N[2022-10-22 20:00:00],
        start: ~N[2022-10-22 20:00:00],
        activity_id: activity_fixture().id
      })
      |> Atomic.Activities.create_session()

    session
  end

  @doc """
  Generate a speaker.
  """
  def speaker_fixture(attrs \\ %{}) do
    {:ok, speaker} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        name: "some name",
        organization_id: OrganizationsFixtures.organization_fixture().id
      })
      |> Atomic.Activities.create_speaker()

    speaker
  end
end
