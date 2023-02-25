defmodule Atomic.OrganizationsTest do
  use Atomic.DataCase

  alias Atomic.Organizations

  describe "organizations" do
    alias Atomic.Organizations.Organization

    import Atomic.OrganizationsFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Organization{} = organization} =
               Organizations.create_organization(valid_attrs)

      assert organization.description == "some description"
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Organization{} = organization} =
               Organizations.update_organization(organization, update_attrs)

      assert organization.description == "some updated description"
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_organization(organization, @invalid_attrs)

      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end

  describe "memberships" do
    alias Atomic.Organizations.Membership
    import Atomic.OrganizationsFixtures

    test "list_memberships/1 returns all memberships of organization" do
      membership = membership_fixture()

      assert Organizations.list_memberships(%{"organization_id" => membership.organization_id}) ==
               [membership]
    end

    test "list_memberships/1 returns all memberships of user" do
      membership = membership_fixture()
      assert Organizations.list_memberships(%{"user_id" => membership.user_id}) == [membership]
    end

    test "get_membership!/1 returns the given membership" do
      membership = membership_fixture()
      assert Organizations.get_membership!(membership.id) == membership
    end

    test "get_membership!/1 gives an error if ID does not exist" do
      membership = membership_fixture()

      assert_raise Ecto.NoResultsError, fn ->
        Organizations.get_membership!(Ecto.UUID.generate())
      end
    end

    test "update_membership/2 with valid data updates the membership" do
      membership = membership_fixture()

      attrs = %{
        number: 42
      }

      assert {:ok, %Membership{} = membership} =
               Organizations.update_membership(membership, attrs)

      assert membership.number == 42
    end

    test "update_membership/2 with invalid data updates the membership" do
      membership = membership_fixture()

      attrs = %{
        user_id: nil,
        number: 42
      }

      assert {:error, %Ecto.Changeset{}} = Organizations.update_membership(membership, attrs)
      assert Organizations.get_membership!(membership.id) == membership
    end

    test "delete_membership/1 deletes the membership" do
      membership = membership_fixture()
      assert {:ok, %Membership{}} = Organizations.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_membership!(membership.id) end
    end

    test "change_membership/1 returns an membership changeset" do
      membership = membership_fixture()
      assert %Ecto.Changeset{} = Organizations.change_membership(membership)
    end
  end
  describe "departments" do
    alias Atomic.OrganizationsTest.Department
    import Atomic.OrganizationsFixtures

    @invalid_attrs %{name: nil}

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert Organizations.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Organizations.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Department{} = department} = Organizations.create_department(valid_attrs)
      assert department.name == "some name"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Department{} = department} =
               Organizations.update_department(department, update_attrs)

      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_department(department, @invalid_attrs)

      assert department == Organizations.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Organizations.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Organizations.change_department(department)
    end
  end
end
