defmodule AtomicWeb.PartnerLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.PartnershipsFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_partner(_) do
    partner = partner_fixture()
    %{partner: partner}
  end

  describe "Index" do
    setup [:create_partner]
    setup [:register_and_log_in_user]

    test "lists all partnerships", %{conn: conn, partner: partner} do
      {:ok, _index_live, html} = live(conn, Routes.partner_index_path(conn, :index))

      assert html =~ "Listing Partnerships"
      assert html =~ partner.description
    end

    test "saves new partner", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.partner_index_path(conn, :index))

      assert index_live |> element("a", "New Partner") |> render_click() =~
               "New Partner"

      assert_patch(index_live, Routes.partner_index_path(conn, :new))

      assert index_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#partner-form", partner: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.partner_index_path(conn, :index))

      assert html =~ "some description"
    end

    test "updates partner in listing", %{conn: conn, partner: partner} do
      {:ok, index_live, _html} = live(conn, Routes.partner_index_path(conn, :index))

      assert index_live |> element("#partner-#{partner.id} a", "Edit") |> render_click() =~
               "Edit Partner"

      assert_patch(index_live, Routes.partner_index_path(conn, :edit, partner))

      assert index_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#partner-form", partner: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.partner_index_path(conn, :index))

      assert html =~ "some updated description"
    end

    test "deletes partner in listing", %{conn: conn, partner: partner} do
      {:ok, index_live, _html} = live(conn, Routes.partner_index_path(conn, :index))

      assert index_live |> element("#partner-#{partner.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#partner-#{partner.id}")
    end
  end

  describe "Show" do
    setup [:create_partner]
    setup [:register_and_log_in_user]

    test "displays partner", %{conn: conn, partner: partner} do
      {:ok, _show_live, html} = live(conn, Routes.partner_show_path(conn, :show, partner))

      assert html =~ "Show Partner"
      assert html =~ partner.description
    end

    test "updates partner within modal", %{conn: conn, partner: partner} do
      {:ok, show_live, _html} = live(conn, Routes.partner_show_path(conn, :show, partner))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Partner"

      assert_patch(show_live, Routes.partner_show_path(conn, :edit, partner))

      assert show_live
             |> form("#partner-form", partner: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#partner-form", partner: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.partner_show_path(conn, :show, partner))

      assert html =~ "some updated description"
    end
  end
end
