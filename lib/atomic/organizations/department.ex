defmodule Atomic.Organizations.Department do
  @moduledoc """
    A department of an organization
  """
  use Atomic.Schema
  alias Atomic.Organizations.Organization

  @required_fields ~w(name organization_id)a
  @optional_fields ~w(description select)a

  schema "departments" do
    field :name, :string
    field :description, :string

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    field :select, :boolean, virtual: true

    timestamps()
  end

  def changeset(department, attrs) do
    department
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
