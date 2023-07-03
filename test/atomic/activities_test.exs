defmodule Atomic.ActivitiesTest do
  use Atomic.DataCase

  alias Atomic.Activities
  import Atomic.Factory
  import Atomic.ActivitiesFixtures

  describe "activities" do
    alias Atomic.Activities.Activity

    @invalid_attrs %{description: nil, maximum_entries: nil, minimum_entries: nil, title: nil}

    test "list_activities/0 returns all activities" do
      activity = insert(:activity)
      activities = Activities.list_activities([]) |> Enum.map(& &1.id)
      assert activities == [activity.id]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = insert(:activity)
      assert Activities.get_activity!(activity.id).id == activity.id
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = params_for(:activity)

      assert {:ok, %Activity{}} = Activities.create_activity(valid_attrs)
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = insert(:activity)

      update_attrs = %{
        description: "some updated description",
        maximum_entries: 43,
        minimum_entries: 43,
        title: "some updated title"
      }

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.description == "some updated description"
      assert activity.maximum_entries == 43
      assert activity.minimum_entries == 43
      assert activity.title == "some updated title"
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

  describe "sessions" do
    alias Atomic.Activities.Session

    @invalid_attrs %{finish: nil, start: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Activities.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Activities.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{finish: ~N[2022-10-22 20:00:00], start: ~N[2022-10-22 20:00:00]}

      assert {:ok, %Session{} = session} = Activities.create_session(valid_attrs)
      assert session.finish == ~N[2022-10-22 20:00:00]
      assert session.start == ~N[2022-10-22 20:00:00]
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{finish: ~N[2022-10-23 20:00:00], start: ~N[2022-10-23 20:00:00]}

      assert {:ok, %Session{} = session} = Activities.update_session(session, update_attrs)
      assert session.finish == ~N[2022-10-23 20:00:00]
      assert session.start == ~N[2022-10-23 20:00:00]
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_session(session, @invalid_attrs)
      assert session == Activities.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Activities.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Activities.change_session(session)
    end
  end

  describe "enrollments" do
    alias Atomic.Activities.Enrollment

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

      assert {:ok, %Enrollment{}} = Activities.create_enrollment(activity, user)
    end

    test "update_enrollment/2 with valid data updates the enrollment" do
      enrollment = insert(:enrollment)
      update_attrs = %{}

      assert {:ok, %Enrollment{}} = Activities.update_enrollment(enrollment, update_attrs)
    end

    test "delete_enrollment/1 deletes the enrollment" do
      enrollment = insert(:enrollment)
      assert {_, nil} = Activities.delete_enrollment(enrollment.activity, enrollment.user)
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
      valid_attrs = %{bio: "some bio", name: "some name"}

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
