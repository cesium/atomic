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

  describe "associations" do
    alias Atomic.Organizations.Association
    import Atomic.OrganizationsFixtures

    test "list_associations/1 returns all associations of organization" do
      association = association_fixture()

      assert Organizations.list_associations(%{"organization_id" => association.organization_id}) ==
               [association]
    end

    test "list_associations/1 returns all associations of user" do
      association = association_fixture()
      assert Organizations.list_associations(%{"user_id" => association.user_id}) == [association]
    end

    test "get_association!/1 returns the given association" do
      association = association_fixture()
      assert Organizations.get_association!(association.id) == association
    end

    test "get_association!/1 gives an error if ID does not exist" do
      association = association_fixture()

      assert_raise Ecto.NoResultsError, fn ->
        Organizations.get_association!(Ecto.UUID.generate())
      end
    end

    test "update_association/2 with valid data updates the association" do
      association = association_fixture()

      attrs = %{
        accepted: true,
        number: 42
      }

      assert {:ok, %Association{} = association} =
               Organizations.update_association(association, attrs)

      assert association.number == 42
      assert association.accepted
    end

    test "update_association/2 with invalid data updates the association" do
      association = association_fixture()

      attrs = %{
        accepted: nil,
        number: 42
      }

      assert {:error, %Ecto.Changeset{}} = Organizations.update_association(association, attrs)
      assert Organizations.get_association!(association.id) == association
    end

    test "delete_association/1 deletes the association" do
      association = association_fixture()
      assert {:ok, %Association{}} = Organizations.delete_association(association)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_association!(association.id) end
    end

    test "change_association/1 returns an Association changeset" do
      association = association_fixture()
      assert %Ecto.Changeset{} = Organizations.change_association(association)
    end
  end
end
