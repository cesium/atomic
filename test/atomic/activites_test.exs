defmodule Atomic.ActivitesTest do
  use Atomic.DataCase

  alias Atomic.Activites

  describe "activies" do
    alias Atomic.Activites.Activity

    import Atomic.ActivitesFixtures

    @invalid_attrs %{capacity: nil, date: nil, description: nil, location: nil, title: nil}

    test "list_activies/0 returns all activies" do
      activity = activity_fixture()
      assert Activites.list_activies() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activites.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{capacity: 42, date: ~U[2022-10-19 15:58:00Z], description: "some description", location: "some location", title: "some title"}

      assert {:ok, %Activity{} = activity} = Activites.create_activity(valid_attrs)
      assert activity.capacity == 42
      assert activity.date == ~U[2022-10-19 15:58:00Z]
      assert activity.description == "some description"
      assert activity.location == "some location"
      assert activity.title == "some title"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activites.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{capacity: 43, date: ~U[2022-10-20 15:58:00Z], description: "some updated description", location: "some updated location", title: "some updated title"}

      assert {:ok, %Activity{} = activity} = Activites.update_activity(activity, update_attrs)
      assert activity.capacity == 43
      assert activity.date == ~U[2022-10-20 15:58:00Z]
      assert activity.description == "some updated description"
      assert activity.location == "some updated location"
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activites.update_activity(activity, @invalid_attrs)
      assert activity == Activites.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activites.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activites.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activites.change_activity(activity)
    end
  end
end
