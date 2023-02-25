defmodule AtomicWeb.InstructorLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.ActivitiesFixtures

  @create_attrs %{bio: "some bio", name: "some name"}
  @update_attrs %{bio: "some updated bio", name: "some updated name"}
  @invalid_attrs %{bio: nil, name: nil}

  defp create_instructor(_) do
    instructor = instructor_fixture()
    %{instructor: instructor}
  end

  describe "Index" do
    setup [:create_instructor]

    test "lists all instructors", %{conn: conn, instructor: instructor} do
      {:ok, _index_live, html} = live(conn, Routes.instructor_index_path(conn, :index))

      assert html =~ "Listing Instructors"
      assert html =~ instructor.bio
    end

    test "saves new instructor", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.instructor_index_path(conn, :index))

      assert index_live |> element("a", "New Instructor") |> render_click() =~
               "New Instructor"

      assert_patch(index_live, Routes.instructor_index_path(conn, :new))

      assert index_live
             |> form("#instructor-form", instructor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instructor-form", instructor: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instructor_index_path(conn, :index))

      assert html =~ "Instructor created successfully"
      assert html =~ "some bio"
    end

    test "updates instructor in listing", %{conn: conn, instructor: instructor} do
      {:ok, index_live, _html} = live(conn, Routes.instructor_index_path(conn, :index))

      assert index_live |> element("#instructor-#{instructor.id} a", "Edit") |> render_click() =~
               "Edit Instructor"

      assert_patch(index_live, Routes.instructor_index_path(conn, :edit, instructor))

      assert index_live
             |> form("#instructor-form", instructor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#instructor-form", instructor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instructor_index_path(conn, :index))

      assert html =~ "Instructor updated successfully"
      assert html =~ "some updated bio"
    end

    test "deletes instructor in listing", %{conn: conn, instructor: instructor} do
      {:ok, index_live, _html} = live(conn, Routes.instructor_index_path(conn, :index))

      assert index_live |> element("#instructor-#{instructor.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#instructor-#{instructor.id}")
    end
  end

  describe "Show" do
    setup [:create_instructor]

    test "displays instructor", %{conn: conn, instructor: instructor} do
      {:ok, _show_live, html} = live(conn, Routes.instructor_show_path(conn, :show, instructor))

      assert html =~ "Show Instructor"
      assert html =~ instructor.bio
    end

    test "updates instructor within modal", %{conn: conn, instructor: instructor} do
      {:ok, show_live, _html} = live(conn, Routes.instructor_show_path(conn, :show, instructor))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Instructor"

      assert_patch(show_live, Routes.instructor_show_path(conn, :edit, instructor))

      assert show_live
             |> form("#instructor-form", instructor: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#instructor-form", instructor: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.instructor_show_path(conn, :show, instructor))

      assert html =~ "Instructor updated successfully"
      assert html =~ "some updated bio"
    end
  end
end
