defmodule Atomic.Organizations.Department do
  @moduledoc """
    A department of an organization
  """
  use Atomic.Schema
  alias Atomic.Organizations.Organization
  alias Atomic.Activities.{Activity, ActivityDepartment}

  @required_fields ~w(name organization_id)a

  @optional_fields []

  schema "departments" do
    field :name, :string

    many_to_many :activities, Activity, join_through: ActivityDepartment, on_replace: :delete

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
