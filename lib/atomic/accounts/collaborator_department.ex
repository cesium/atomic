defmodule Atomic.Users.CollaboratorDepartment do
  @moduledoc """
    An activity speaker
  """
  use Atomic.Schema

  alias Atomic.Departments.Department
  alias Atomic.Accounts.Collaborator

  @required_fields ~w(collaborator_id department_id)a

  schema "collaborator_departments" do
    belongs_to :collaborator, Collaborator
    belongs_to :department, Department

    timestamps()
  end

  def changeset(collaborator_departments, attrs) do
    collaborator_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(collaborator_departments, attrs) do
    collaborator_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
