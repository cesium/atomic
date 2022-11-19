defmodule AtomicWeb.SessionLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.ActivitiesFixtures

  @create_attrs %{
    finish: %{day: 22, hour: 20, minute: 0, month: 10, year: 2022},
    start: %{day: 22, hour: 20, minute: 0, month: 10, year: 2022}
  }
  @update_attrs %{
    finish: %{day: 23, hour: 20, minute: 0, month: 10, year: 2022},
    start: %{day: 23, hour: 20, minute: 0, month: 10, year: 2022}
  }
  @invalid_attrs %{
    finish: %{day: 30, hour: 20, minute: 0, month: 2, year: 2022},
    start: %{day: 30, hour: 20, minute: 0, month: 2, year: 2022}
  }

  defp create_session(_) do
    session = session_fixture()
    %{session: session}
  end

  describe "Index" do
    setup [:create_session]

    test "lists all sessions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Listing Sessions"
    end

    test "saves new session", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("a", "New Session") |> render_click() =~
               "New Session"

      assert_patch(index_live, Routes.session_index_path(conn, :new))

      assert index_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#session-form", session: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Session created successfully"
    end

    test "updates session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("#session-#{session.id} a", "Edit") |> render_click() =~
               "Edit Session"

      assert_patch(index_live, Routes.session_index_path(conn, :edit, session))

      assert index_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#session-form", session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Session updated successfully"
    end

    test "deletes session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("#session-#{session.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#session-#{session.id}")
    end
  end

  describe "Show" do
    setup [:create_session]

    test "displays session", %{conn: conn, session: session} do
      {:ok, _show_live, html} = live(conn, Routes.session_show_path(conn, :show, session))

      assert html =~ "Show Session"
    end

    test "updates session within modal", %{conn: conn, session: session} do
      {:ok, show_live, _html} = live(conn, Routes.session_show_path(conn, :show, session))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Session"

      assert_patch(show_live, Routes.session_show_path(conn, :edit, session))

      assert show_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#session-form", session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_show_path(conn, :show, session))

      assert html =~ "Session updated successfully"
    end
  end
end
