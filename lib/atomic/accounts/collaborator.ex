defmodule Atomic.Accounts.Collaborator do
  use Atomic.Schema
  alias Atomic.Departments.Department
  alias Atomic.Accounts.User
  alias Atomic.Users.CollaboratorDepartment

  @required_fields ~w(name organization_id user_id)a
  schema "collaborators" do
    many_to_many :departments, Department, join_through: CollaboratorDepartment
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(collaborator, attrs) do
    collaborator
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
