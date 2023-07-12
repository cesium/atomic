defmodule Atomic.Factories.OrganizationFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Organizations.{Membership, Organization, UserOrganization}

  defmacro __using__(_opts) do
    quote do
      @roles ~w(follower member admin owner)a

      def organization_factory do
        %Organization{
          name: Faker.Company.name(),
          description: Faker.Lorem.paragraph()
        }
      end

      def membership_factory do
        %Membership{
          user: build(:user),
          created_by: build(:user, role: "staff"),
          organization: build(:organization),
          role: Enum.random(@roles)
        }
      end

      def user_organization_factory do
        %UserOrganization{
          user: build(:user),
          title: Faker.Company.bullshit(),
          organization: build(:organization),
          year: "2021/2022"
        }
      end
    end
  end
end
