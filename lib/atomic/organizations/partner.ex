defmodule Atomic.Organizations.Partner do
  @moduledoc """
    A partnership.
  """
  use Atomic.Schema

  alias Atomic.Organizations.Organization
  alias Atomic.Uploaders

  @required_fields ~w(name organization_id)a
  @optional_fields ~w(description image)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order: %{
      order_by: [:name],
      order_directions: [:asc]
    }
  }

  schema "partnerships" do
    field :name, :string
    field :description, :string
    field :image, Uploaders.Image.Type

    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(partner, attrs) do
    partner
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def image_changeset(partner, attrs) do
    partner
    |> cast_attachments(attrs, [:image])
  end
end
