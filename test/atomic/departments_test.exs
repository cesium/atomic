defmodule Atomic.DepartmentsTest do
  use Atomic.DataCase

  alias Atomic.Departments

  describe "departments" do
    alias Atomic.Departments.Department

    import Atomic.DepartmentsFixtures

    @invalid_attrs %{name: nil}

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert Departments.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Departments.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Department{} = department} = Departments.create_department(valid_attrs)
      assert department.name == "some name"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Departments.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Department{} = department} =
               Departments.update_department(department, update_attrs)

      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Departments.update_department(department, @invalid_attrs)

      assert department == Departments.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Departments.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Departments.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Departments.change_department(department)
    end
  end
end
