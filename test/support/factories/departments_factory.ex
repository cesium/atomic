defmodule Atomic.Factories.DepartmentFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Departments.Department

  defmacro __using__(_opts) do
    quote do
      @departments [
        "Pedagogical Department",
        "CAOS Department",
        "Department of Image",
        "Department of Partnerships",
        "Recreational Department"
      ]

      def department_factory do
        organization = insert(:organization)

        %Department{
          name: Enum.random(@departments),
          organization_id: organization.id
        }
      end
    end
  end
end
