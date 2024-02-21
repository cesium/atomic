defmodule Atomic.Factories.OrganizationFactory do
  @moduledoc """
  A factory to generate organization related structs
  """
  alias Atomic.Ecto.Year

  alias Atomic.Organizations.{
    Announcement,
    Board,
    BoardDepartments,
    Membership,
    Organization,
    UserOrganization
  }

  defmacro __using__(_opts) do
    quote do
      @roles ~w(member admin owner)a

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
          created_by: build(:user, role: "admin"),
          organization: build(:organization),
          role: Enum.random(@roles)
        }
      end

      def board_factory do
        %Board{
          year: Year.current_year(),
          organization: build(:organization)
        }
      end

      def board_department_factory do
        %BoardDepartments{
          name: Faker.Company.buzzword(),
          priority: Enum.random(0..4),
          board: build(:board)
        }
      end

      def user_organization_factory do
        %UserOrganization{
          user: build(:user),
          role: Faker.Company.bullshit(),
          board_departments_id: build(:board_department).id,
          priority: Enum.random(0..4)
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
