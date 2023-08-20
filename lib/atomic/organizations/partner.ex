defmodule Atomic.Organizations.Partner do
  @moduledoc """
    A partnership between an organization and a partner.
  """
  use Atomic.Schema

  alias Atomic.Organizations.Organization
  alias Atomic.Uploaders

  @required_fields ~w(name description organization_id)a
  @optional_fields ~w(state image)a
  @states ~w(active inactive)a

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
    field :state, Ecto.Enum, values: @states, default: :active
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
end
