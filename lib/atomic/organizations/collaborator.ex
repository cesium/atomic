defmodule Atomic.Organizations.Collaborator do
  @moduledoc """
    A relation representing an organization department collaborator.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Department

  @required_fields ~w(user_id department_id)a
  @optional_fields ~w(accepted)a

  schema "collaborators" do
    belongs_to :user, User
    belongs_to :department, Department
    field :accepted, :boolean, default: false
    timestamps()
  end

  def changeset(collaborator_departments, attrs) do
    collaborator_departments
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(collaborator_departments, attrs) do
    collaborator_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
