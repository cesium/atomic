defmodule Atomic.DepartmentsTest do
  use Atomic.DataCase

  alias Atomic.Departments

  import Atomic.Factory

  describe "departments" do
    alias Atomic.Departments.Department

    @invalid_attrs %{name: nil}

    test "list_departments/0 returns all departments" do
      department = insert(:department)

      departments_id =
        Departments.list_departments()
        |> Enum.map(fn department -> department.id end)

      assert departments_id == [department.id]
    end

    test "get_department!/1 returns the department with given id" do
      department = insert(:department)
      assert Departments.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      # valid_attrs = %{name: "some name"}
      valid_attrs = params_for(:department)

      assert {:ok, %Department{} = department} = Departments.create_department(valid_attrs)
      assert department.name == valid_attrs.name
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Departments.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = insert(:department)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Department{} = department} =
               Departments.update_department(department, update_attrs)

      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = insert(:department)

      assert {:error, %Ecto.Changeset{}} =
               Departments.update_department(department, @invalid_attrs)

      assert department == Departments.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = insert(:department)
      assert {:ok, %Department{}} = Departments.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Departments.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = insert(:department)
      assert %Ecto.Changeset{} = Departments.change_department(department)
    end
  end
end
