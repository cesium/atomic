defmodule Atomic.Departments.Department do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Accounts.Collaborator
  alias Atomic.Users.CollaboratorDepartment

  @required_fields ~w(name)a

  @optional_fields []

  schema "departments" do
    field :name, :string

    has_many :activities, Activity

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
