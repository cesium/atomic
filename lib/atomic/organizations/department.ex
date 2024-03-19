defmodule Atomic.Organizations.Department do
  @moduledoc """
    A department of an organization
  """
  use Atomic.Schema
  alias Atomic.Organizations.Organization
  alias Atomic.Uploaders

  @required_fields ~w(name organization_id)a
  @optional_fields ~w(description collaborator_applications)a

  schema "departments" do
    field :name, :string
    field :description, :string
    field :banner, Atomic.Uploaders.Banner.Type
    field :collaborator_applications, :boolean, default: false

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    timestamps()
  end

  def changeset(department, attrs) do
    department
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
