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
end
