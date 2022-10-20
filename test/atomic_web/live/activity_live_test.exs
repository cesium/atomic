defmodule AtomicWeb.ActivityLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.ActivitesFixtures

  @create_attrs %{capacity: 42, date: %{day: 19, hour: 15, minute: 58, month: 10, year: 2022}, description: "some description", location: "some location", title: "some title"}
  @update_attrs %{capacity: 43, date: %{day: 20, hour: 15, minute: 58, month: 10, year: 2022}, description: "some updated description", location: "some updated location", title: "some updated title"}
  @invalid_attrs %{capacity: nil, date: %{day: 30, hour: 15, minute: 58, month: 2, year: 2022}, description: nil, location: nil, title: nil}

  defp create_activity(_) do
    activity = activity_fixture()
    %{activity: activity}
  end

  describe "Index" do
    setup [:create_activity]

    test "lists all activies", %{conn: conn, activity: activity} do
      {:ok, _index_live, html} = live(conn, Routes.activity_index_path(conn, :index))

      assert html =~ "Listing Activies"
      assert html =~ activity.description
    end

    test "saves new activity", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.activity_index_path(conn, :index))

      assert index_live |> element("a", "New Activity") |> render_click() =~
               "New Activity"

      assert_patch(index_live, Routes.activity_index_path(conn, :new))

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#activity-form", activity: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_index_path(conn, :index))

      assert html =~ "Activity created successfully"
      assert html =~ "some description"
    end

    test "updates activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, Routes.activity_index_path(conn, :index))

      assert index_live |> element("#activity-#{activity.id} a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(index_live, Routes.activity_index_path(conn, :edit, activity))

      assert index_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#activity-form", activity: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_index_path(conn, :index))

      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes activity in listing", %{conn: conn, activity: activity} do
      {:ok, index_live, _html} = live(conn, Routes.activity_index_path(conn, :index))

      assert index_live |> element("#activity-#{activity.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#activity-#{activity.id}")
    end
  end

  describe "Show" do
    setup [:create_activity]

    test "displays activity", %{conn: conn, activity: activity} do
      {:ok, _show_live, html} = live(conn, Routes.activity_show_path(conn, :show, activity))

      assert html =~ "Show Activity"
      assert html =~ activity.description
    end

    test "updates activity within modal", %{conn: conn, activity: activity} do
      {:ok, show_live, _html} = live(conn, Routes.activity_show_path(conn, :show, activity))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Activity"

      assert_patch(show_live, Routes.activity_show_path(conn, :edit, activity))

      assert show_live
             |> form("#activity-form", activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#activity-form", activity: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.activity_show_path(conn, :show, activity))

      assert html =~ "Activity updated successfully"
      assert html =~ "some updated description"
    end
  end
end
