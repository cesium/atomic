defmodule AtomicWeb.DepartmentLiveTest do
  use AtomicWeb.ConnCase

  import Phoenix.LiveViewTest
  import Atomic.Factory

  defp create_department(_) do
    department = insert(:department)
    %{department: department}
  end

  describe "Index" do
    setup [:create_department]
    setup [:register_and_log_in_user]

    test "lists all departments", %{conn: conn, department: department} do
      {:ok, _index_live, html} = live(conn, Routes.department_index_path(conn, :index))

      assert html =~ "Listing Departments"
      assert html =~ department.name
    end

    test "deletes department in listing", %{conn: conn, department: department} do
      {:ok, index_live, _html} = live(conn, Routes.department_index_path(conn, :index))

      assert index_live |> element("#department-#{department.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#department-#{department.id}")
    end
  end
end
