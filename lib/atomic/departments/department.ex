defmodule Atomic.Departments.Department do
  @moduledoc """
    An activity
  """
  use Atomic.Schema
  alias Atomic.Users.CollaboratorDepartment
  alias Atomic.Organizations.Organization
  alias Atomic.Activities.Activity
  alias Atomic.Accounts.User
  alias Atomic.Activities.ActivityDepartment

  @required_fields ~w(name organization_id)a

  @optional_fields []

  schema "departments" do
    field :name, :string
    many_to_many :collaborators, User, join_through: CollaboratorDepartment
    many_to_many :activities, Activity, join_through: ActivityDepartment

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
