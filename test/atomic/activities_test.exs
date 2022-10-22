defmodule Atomic.ActivitiesTest do
  use Atomic.DataCase

  alias Atomic.Activities

  describe "activities" do
    alias Atomic.Activities.Activity

    import Atomic.ActivitiesFixtures

    @invalid_attrs %{description: nil, maximum_entries: nil, minimum_entries: nil, title: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{description: "some description", maximum_entries: 42, minimum_entries: 42, title: "some title"}

      assert {:ok, %Activity{} = activity} = Activities.create_activity(valid_attrs)
      assert activity.description == "some description"
      assert activity.maximum_entries == 42
      assert activity.minimum_entries == 42
      assert activity.title == "some title"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{description: "some updated description", maximum_entries: 43, minimum_entries: 43, title: "some updated title"}

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.description == "some updated description"
      assert activity.maximum_entries == 43
      assert activity.minimum_entries == 43
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
