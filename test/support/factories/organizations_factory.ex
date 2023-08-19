defmodule Atomic.Factories.OrganizationFactory do
  @moduledoc """
  A factory to generate account related structs
  """
  alias Atomic.Organizations.{Board, BoardDepartments, Membership, Organization, UserOrganization}

  import AtomicWeb.Helpers

  defmacro __using__(_opts) do
    quote do
      @roles ~w(member admin owner)a

      def organization_factory do
        %Organization{
          name: Faker.Company.name(),
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
          year: build_current_academic_year(),
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
    end
  end
end
