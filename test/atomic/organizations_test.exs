defmodule Atomic.OrganizationsTest do
  use Atomic.DataCase

  alias Atomic.Organizations
  import Atomic.Factory

  describe "organizations" do
    alias Atomic.Organizations.Organization

    @invalid_attrs %{description: nil, name: nil}

    test "list_organizations/0 returns all organizations" do
      organization = insert(:organization)

      organizations =
        Organizations.list_organizations([])
        |> Enum.map(& &1.id)

      assert organizations == [organization.id]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = insert(:organization)
      assert Organizations.get_organization!(organization.id).id == organization.id
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
      organization = insert(:organization)
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Organization{} = organization} =
               Organizations.update_organization(organization, update_attrs)

      assert organization.description == "some updated description"
      assert organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = insert(:organization)

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_organization(organization, @invalid_attrs)

      assert organization.id == Organizations.get_organization!(organization.id).id
    end

    test "delete_organization/1 deletes the organization" do
      organization = insert(:organization)
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = insert(:organization)
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end

  describe "memberships" do
    alias Atomic.Organizations.Membership

    test "list_memberships/1 returns all memberships of organization" do
      membership = insert(:membership, role: :member)

      memberships =
        Organizations.list_memberships(%{"organization_id" => membership.organization_id})
        |> Enum.map(& &1.id)

      assert memberships == [membership.id]
    end

    test "list_memberships/1 returns all memberships of user" do
      membership = insert(:membership)

      memberships =
        Organizations.list_memberships(%{"user_id" => membership.user_id})
        |> Enum.map(& &1.id)

      assert memberships == [membership.id]
    end

    test "get_membership!/1 returns the given membership" do
      membership = insert(:membership)
      assert Organizations.get_membership!(membership.id).id == membership.id
    end

    test "get_membership!/1 gives an error if ID does not exist" do
      insert(:membership)

      assert_raise Ecto.NoResultsError, fn ->
        Organizations.get_membership!(Ecto.UUID.generate())
      end
    end

    test "update_membership/2 with valid data updates the membership" do
      membership = insert(:membership)

      attrs = %{
        number: 42
      }

      assert {:ok, %Membership{} = membership} =
               Organizations.update_membership(membership, attrs)

      assert membership.number == 42
    end

    test "update_membership/2 with invalid data updates the membership" do
      membership = insert(:membership)

      attrs = %{
        user_id: nil,
        number: 42
      }

      assert {:error, %Ecto.Changeset{}} = Organizations.update_membership(membership, attrs)
      assert Organizations.get_membership!(membership.id).id == membership.id
    end

    test "delete_membership/1 deletes the membership" do
      membership = insert(:membership)
      assert {:ok, %Membership{}} = Organizations.delete_membership(membership)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_membership!(membership.id) end
    end

    test "change_membership/1 returns an membership changeset" do
      membership = insert(:membership)
      assert %Ecto.Changeset{} = Organizations.change_membership(membership)
    end
  end

  describe "board" do
    test "list_users_organizations/2 returns none users organizations" do
      assert Organizations.list_users_organizations() == []
    end

    test "list_users_organizations/2 returns all users organizations" do
      user_organization = insert(:user_organization)
      organizations = Organizations.list_users_organizations() |> Enum.map(& &1.id)

      assert organizations == [user_organization.id]
    end

    test "get_user_organization!/2 raises Ecto.NoResultsError" do
      insert(:user_organization)

      assert_raise Ecto.NoResultsError,
                   fn -> Organizations.get_user_organization!(Ecto.UUID.generate()) end
    end

    test "get_user_organization!/2 returns existing user organization" do
      user_organization = insert(:user_organization)

      assert Organizations.get_user_organization!(user_organization.id).id ==
               user_organization.id
    end

    test "update_user_organization/2 updates existing user_organization" do
      user_organization = insert(:user_organization)
      board_department = insert(:board_department)

      {:ok, new_user_organization} =
        Organizations.update_user_organization(user_organization, %{
          role: "Vice-Presidente",
          board_departments_id: board_department.id
        })

      assert new_user_organization.role == "Vice-Presidente"
    end

    test "delete_user_organization/1 deletes existing user organization" do
      user_organization = insert(:user_organization)

      assert {:ok, _} = Organizations.delete_user_organization(user_organization)
      assert Organizations.list_users_organizations() == []
    end

    test "change_user_organization/2 returns a changeset" do
      user_organization = insert(:user_organization)

      assert %Ecto.Changeset{} =
               Organizations.change_user_organization(user_organization, %{
                 role: "Vice-Presidente"
               })
    end
  end

  describe "announcement" do
    test "list_published_announcements_by_organization_id/1 returns all published announcement of organization" do
      announcement = insert(:announcement)

      announcements_published =
        Organizations.list_published_announcements_by_organization_id(
          announcement.organization_id
        )

      assert announcement.id == hd(announcements_published).id

      announcement =
        insert(:announcement, publish_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 1, :day))

      announcements_published =
        Organizations.list_published_announcements_by_organization_id(
          announcement.organization_id
        )

      assert announcements_published == []
    end
  end
end
