defmodule AtomicWeb.EnrollmentLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.ActivitiesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_enrollment(_) do
    enrollment = enrollment_fixture()
    %{enrollment: enrollment}
  end

  describe "Index" do
    setup [:create_enrollment]

    test "lists all enrollments", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.enrollment_index_path(conn, :index))

      assert html =~ "Listing Enrollments"
    end

    test "saves new enrollment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.enrollment_index_path(conn, :index))

      assert index_live |> element("a", "New Enrollment") |> render_click() =~
               "New Enrollment"

      assert_patch(index_live, Routes.enrollment_index_path(conn, :new))

      assert index_live
             |> form("#enrollment-form", enrollment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#enrollment-form", enrollment: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.enrollment_index_path(conn, :index))

      assert html =~ "Enrollment created successfully"
    end

    test "updates enrollment in listing", %{conn: conn, enrollment: enrollment} do
      {:ok, index_live, _html} = live(conn, Routes.enrollment_index_path(conn, :index))

      assert index_live |> element("#enrollment-#{enrollment.id} a", "Edit") |> render_click() =~
               "Edit Enrollment"

      assert_patch(index_live, Routes.enrollment_index_path(conn, :edit, enrollment))

      assert index_live
             |> form("#enrollment-form", enrollment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#enrollment-form", enrollment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.enrollment_index_path(conn, :index))

      assert html =~ "Enrollment updated successfully"
    end

    test "deletes enrollment in listing", %{conn: conn, enrollment: enrollment} do
      {:ok, index_live, _html} = live(conn, Routes.enrollment_index_path(conn, :index))

      assert index_live |> element("#enrollment-#{enrollment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#enrollment-#{enrollment.id}")
    end
  end

  describe "Show" do
    setup [:create_enrollment]

    test "displays enrollment", %{conn: conn, enrollment: enrollment} do
      {:ok, _show_live, html} = live(conn, Routes.enrollment_show_path(conn, :show, enrollment))

      assert html =~ "Show Enrollment"
    end

    test "updates enrollment within modal", %{conn: conn, enrollment: enrollment} do
      {:ok, show_live, _html} = live(conn, Routes.enrollment_show_path(conn, :show, enrollment))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Enrollment"

      assert_patch(show_live, Routes.enrollment_show_path(conn, :edit, enrollment))

      assert show_live
             |> form("#enrollment-form", enrollment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#enrollment-form", enrollment: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.enrollment_show_path(conn, :show, enrollment))

      assert html =~ "Enrollment updated successfully"
    end
  end
end
