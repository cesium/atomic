defmodule AtomicWeb.SpeakerLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.ActivitiesFixtures

  @create_attrs %{bio: "some bio", name: "some name"}
  @update_attrs %{bio: "some updated bio", name: "some updated name"}
  @invalid_attrs %{bio: nil, name: nil}

  defp create_speaker(_) do
    speaker = speaker_fixture()
    %{speaker: speaker}
  end

  describe "Index" do
    setup [:create_speaker]

    test "lists all speakers", %{conn: conn, speaker: speaker} do
      {:ok, _index_live, html} = live(conn, Routes.speaker_index_path(conn, :index))

      assert html =~ "Listing Speakers"
      assert html =~ speaker.bio
    end

    test "saves new speaker", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.speaker_index_path(conn, :index))

      assert index_live |> element("a", "New Speaker") |> render_click() =~
               "New Speaker"

      assert_patch(index_live, Routes.speaker_index_path(conn, :new))

      assert index_live
             |> form("#speaker-form", speaker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#speaker-form", speaker: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speaker_index_path(conn, :index))

      assert html =~ "Speaker created successfully"
      assert html =~ "some bio"
    end

    test "updates speaker in listing", %{conn: conn, speaker: speaker} do
      {:ok, index_live, _html} = live(conn, Routes.speaker_index_path(conn, :index))

      assert index_live |> element("#speaker-#{speaker.id} a", "Edit") |> render_click() =~
               "Edit Speaker"

      assert_patch(index_live, Routes.speaker_index_path(conn, :edit, speaker))

      assert index_live
             |> form("#speaker-form", speaker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#speaker-form", speaker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speaker_index_path(conn, :index))

      assert html =~ "Speaker updated successfully"
      assert html =~ "some updated bio"
    end

    test "deletes speaker in listing", %{conn: conn, speaker: speaker} do
      {:ok, index_live, _html} = live(conn, Routes.speaker_index_path(conn, :index))

      assert index_live |> element("#speaker-#{speaker.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#speaker-#{speaker.id}")
    end
  end

  describe "Show" do
    setup [:create_speaker]

    test "displays speaker", %{conn: conn, speaker: speaker} do
      {:ok, _show_live, html} = live(conn, Routes.speaker_show_path(conn, :show, speaker))

      assert html =~ "Show Speaker"
      assert html =~ speaker.bio
    end

    test "updates speaker within modal", %{conn: conn, speaker: speaker} do
      {:ok, show_live, _html} = live(conn, Routes.speaker_show_path(conn, :show, speaker))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Speaker"

      assert_patch(show_live, Routes.speaker_show_path(conn, :edit, speaker))

      assert show_live
             |> form("#speaker-form", speaker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#speaker-form", speaker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speaker_show_path(conn, :show, speaker))

      assert html =~ "Speaker updated successfully"
      assert html =~ "some updated bio"
    end
  end
end
