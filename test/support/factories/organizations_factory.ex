defmodule Atomic.Factories.OrganizationFactory do
  @moduledoc """
  A factory to generate organization related structs.
  """
  alias Atomic.Organizations.{
    Announcement,
    Membership,
    Organization
  }

  defmacro __using__(_opts) do
    quote do
      @roles Membership.roles()

      def organization_factory do
        %Organization{
          name: Faker.Company.name(),
          long_name: Faker.Company.name(),
          description: Faker.Lorem.paragraph()
        }
      end

      def membership_factory do
        %Membership{
          user: build(:user),
          organization: build(:organization),
          role: Enum.random(@roles)
        }
      end

      def announcement_factory do
        organization = insert(:organization)

        %Announcement{
          title: Faker.Company.buzzword(),
          description: Faker.Lorem.paragraph(),
          post: build(:post, type: "announcement"),
          organization_id: organization.id
        }
      end
    end
  end
end
