defmodule Atomic.ActivitiesTest do
  @moduledoc false
  use Atomic.DataCase

  alias Atomic.Activities
  import Atomic.Factory
  import Atomic.ActivitiesFixtures
  alias Atomic.OrganizationsFixtures

  describe "activities" do
    alias Atomic.Activities.Activity

    @invalid_attrs %{description: nil, maximum_entries: nil, minimum_entries: nil, title: nil}

    test "list_activities/1 returns all activities" do
      activity = insert(:activity)
      activities = Activities.list_activities([]) |> Enum.map(& &1.id)

      assert activities == [activity.id]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = insert(:activity)

      assert Activities.get_activity!(activity.id).id == activity.id
    end

    test "create_activity/2 with valid data creates a activity" do
      valid_attrs = params_for(:activity)

      assert {:ok, %Activity{}} = Activities.create_activity(valid_attrs)
    end

    test "create_activity/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "create_activity/2 with maximum_entries lower than minimum_entries" do
      activity = params_for(:activity, maximum_entries: 1, minimum_entries: 2)

      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(activity)
    end

    test "create_activity/2 with finish date before start date" do
      activity = params_for(:activity, finish: ~N[2022-10-21 20:00:00], start: ~N[2022-10-22 20:00:00])

      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(activity)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = insert(:activity)
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Activity{}} = Activities.update_activity(activity, update_attrs)
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = insert(:activity)

      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity.id == Activities.get_activity!(activity.id).id
    end

    test "delete_activity/1 deletes the activity" do
      activity = insert(:activity)

      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = insert(:activity)

      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end

  describe "enrollments" do
    alias Atomic.Activities.ActivityEnrollment

    @invalid_attrs %{}

    test "list_enrollments/0 returns all enrollments" do
      enrollment = insert(:enrollment)
      enrollments = Activities.list_enrollments() |> Enum.map(& &1.id)
      assert enrollments == [enrollment.id]
    end

    test "get_enrollment!/1 returns the enrollment with given id" do
      enrollment = insert(:enrollment)
      assert Activities.get_enrollment!(enrollment.id).id == enrollment.id
    end

    test "create_enrollment/1 with valid data creates a enrollment" do
      user = insert(:user)
      activity = insert(:activity)

      assert {:ok, %ActivityEnrollment{}} = Activities.create_enrollment(activity.id, user)
    end

    test "update_enrollment/2 with valid data updates the enrollment" do
      enrollment = insert(:enrollment)
      update_attrs = %{present: true}

      assert {:ok, %ActivityEnrollment{}} = Activities.update_enrollment(enrollment, update_attrs)
    end

    test "delete_enrollment/1 deletes the enrollment" do
      enrollment = insert(:enrollment)
      assert {_, nil} = Activities.delete_enrollment(enrollment.activity.id, enrollment.user)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_enrollment!(enrollment.id) end
    end

    test "change_enrollment/1 returns a enrollment changeset" do
      enrollment = insert(:enrollment)
      assert %Ecto.Changeset{} = Activities.change_enrollment(enrollment)
    end
  end

  describe "speakers" do
    alias Atomic.Activities.Speaker

    @invalid_attrs %{bio: nil, name: nil}

    test "list_speakers/0 returns all speakers" do
      speaker = speaker_fixture()
      assert Activities.list_speakers() == [speaker]
    end

    test "get_speaker!/1 returns the speaker with given id" do
      speaker = speaker_fixture()
      assert Activities.get_speaker!(speaker.id) == speaker
    end

    test "create_speaker/1 with valid data creates a speaker" do
      valid_attrs = %{
        bio: "some bio",
        name: "some name",
        organization_id: OrganizationsFixtures.organization_fixture().id
      }

      assert {:ok, %Speaker{} = speaker} = Activities.create_speaker(valid_attrs)
      assert speaker.bio == "some bio"
      assert speaker.name == "some name"
    end

    test "create_speaker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_speaker(@invalid_attrs)
    end

    test "update_speaker/2 with valid data updates the speaker" do
      speaker = speaker_fixture()
      update_attrs = %{bio: "some updated bio", name: "some updated name"}

      assert {:ok, %Speaker{} = speaker} = Activities.update_speaker(speaker, update_attrs)
      assert speaker.bio == "some updated bio"
      assert speaker.name == "some updated name"
    end

    test "update_speaker/2 with invalid data returns error changeset" do
      speaker = speaker_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_speaker(speaker, @invalid_attrs)
      assert speaker == Activities.get_speaker!(speaker.id)
    end

    test "delete_speaker/1 deletes the speaker" do
      speaker = speaker_fixture()
      assert {:ok, %Speaker{}} = Activities.delete_speaker(speaker)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_speaker!(speaker.id) end
    end

    test "change_speaker/1 returns a speaker changeset" do
      speaker = speaker_fixture()
      assert %Ecto.Changeset{} = Activities.change_speaker(speaker)
    end
  end
end
