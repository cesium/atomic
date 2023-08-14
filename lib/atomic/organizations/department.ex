defmodule Atomic.Organizations.Department do
  @moduledoc """
    A department of an organization
  """
  use Atomic.Schema
  alias Atomic.Organizations.Organization
  alias Atomic.Activities.{Session, SessionDepartment}

  @required_fields ~w(name organization_id)a
  @optional_fields ~w(description)a

  schema "departments" do
    field :name, :string
    field :description, :string

    many_to_many :sessions, Session, join_through: SessionDepartment, on_replace: :delete
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
