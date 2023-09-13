defmodule Atomic.PartnersTest do
  use Atomic.DataCase

  alias Atomic.Partners

  describe "partners" do
    alias Atomic.Organizations.Partner
    alias Atomic.OrganizationsFixtures
    import Atomic.PartnersFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_partners/0 returns all partners" do
      partner = partner_fixture()
      assert Partners.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert Partners.get_partner!(partner.id) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        organization_id: OrganizationsFixtures.organization_fixture().id
      }

      assert {:ok, %Partner{} = partner} = Partners.create_partner(valid_attrs)

      assert partner.description == "some description"
      assert partner.name == "some name"
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Partner{} = partner} = Partners.update_partner(partner, update_attrs)
      assert partner.description == "some updated description"
      assert partner.name == "some updated name"
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = Partners.update_partner(partner, @invalid_attrs)
      assert partner == Partners.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = Partners.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> Partners.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = Partners.change_partner(partner)
    end
  end
end
