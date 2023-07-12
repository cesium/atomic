defmodule AtomicWeb.OrganizationLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.OrganizationsFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_organization(_) do
    organization = organization_fixture()
    %{organization: organization}
  end

  describe "Index" do
    setup [:create_organization]
    setup [:register_and_log_in_user]

    test "lists all organizations", %{conn: conn, organization: organization} do
      {:ok, _index_live, html} = live(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Listing Organizations"
      assert html =~ organization.description
    end

    test "saves new organization", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live |> element("a", "New Organization") |> render_click() =~
               "New Organization"

      assert_patch(index_live, Routes.organization_index_path(conn, :new))

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Organization created successfully"
      assert html =~ "some description"
    end

    test "updates organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live |> element("#organization-#{organization.id} a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(index_live, Routes.organization_index_path(conn, :edit, organization))

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live
             |> element("#organization-#{organization.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#organization-#{organization.id}")
    end
  end

  describe "Show" do
    setup [:create_organization]
    setup [:register_and_log_in_user]

    test "displays organization", %{conn: conn, organization: organization} do
      {:ok, _show_live, html} =
        live(conn, Routes.organization_show_path(conn, :show, organization))

      assert html =~ "Show Organization"
      assert html =~ organization.description
    end

    test "updates organization within modal", %{conn: conn, organization: organization} do
      {:ok, show_live, _html} =
        live(conn, Routes.organization_show_path(conn, :show, organization))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(show_live, Routes.organization_show_path(conn, :edit, organization))

      assert show_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_show_path(conn, :show, organization))

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated description"
    end
  end
end
