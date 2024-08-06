defmodule Atomic.ActivitiesTest do
  @moduledoc false
  use Atomic.DataCase

  alias Atomic.Activities

  import Atomic.Factory

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

    test "create_activity_with_post/2 with valid data creates a activity" do
      valid_attrs = params_for(:activity)

      assert {:ok, %Activity{}} = Activities.create_activity_with_post(valid_attrs)
    end

    test "create_activity_with_post/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_with_post(@invalid_attrs)
    end

    test "create_activity_with_post/2 with maximum_entries lower than minimum_entries" do
      activity = params_for(:activity, maximum_entries: 1, minimum_entries: 2)

      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_with_post(activity)
    end

    test "create_activity_with_post/2 with finish date before start date" do
      activity =
        params_for(:activity, finish: ~N[2022-10-21 20:00:00], start: ~N[2022-10-22 20:00:00])

      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_with_post(activity)
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
    alias Atomic.Activities.Enrollment

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

      assert {:ok, %Enrollment{}} = Activities.create_enrollment(activity.id, user)
      assert Activities.get_activity!(activity.id).enrolled == 1
    end

    test "update_enrollment/2 with valid data updates the enrollment" do
      enrollment = insert(:enrollment)
      update_attrs = %{present: true}

      assert {:ok, %Enrollment{}} = Activities.update_enrollment(enrollment, update_attrs)
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
end
