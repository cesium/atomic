defmodule Atomic.Organizations.Partner do
  @moduledoc """
  Schema representing a partner of an organization.
  """
  use Atomic.Schema

  alias Atomic.Location
  alias Atomic.Organizations.Organization
  alias Atomic.Socials

  @required_fields ~w(name organization_id)a
  @optional_fields ~w(description benefits archived image notes)a

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

  schema "partners" do
    field :name, :string
    field :description, :string
    field :notes, :string

    field :banner, Atomic.Uploaders.Banner.Type

    field :benefits, :string
    field :archived, :boolean, default: false
    field :image, Uploaders.PartnerImage.Type

    embeds_one :location, Location, on_replace: :update
    embeds_one :socials, Socials, on_replace: :update

    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(partner, attrs) do
    partner
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_embed(:socials, with: &Socials.changeset/2)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def image_changeset(partner, attrs) do
    partner
    |> cast_attachments(attrs, [:image])
  end
end
