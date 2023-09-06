defmodule Atomic.Organizations.Organization do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities.Location
  alias Atomic.Organizations.{Announcement, Board, Card, Department, Membership, Partner}
  alias Atomic.Uploaders

  @required_fields ~w(name slug description)a
  @optional_fields ~w(card_image logo)a

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

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :card_image, Uploaders.Card.Type
    field :logo, Uploaders.Logo.Type
    field :slug, :string

    has_many :departments, Department,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :organization_id,
      preload_order: [asc: :name]

    many_to_many :users, User, join_through: Membership

    has_many :partnerships, Partner,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :organization_id,
      preload_order: [asc: :name]

    embeds_one :location, Location, on_replace: :delete
    embeds_one :card, Card, on_replace: :delete

    has_many :announcements, Announcement,
      on_replace: :delete,
      preload_order: [asc: :inserted_at]

    has_many :boards, Board,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :organization_id,
      preload_order: [asc: :year]

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_embed(:card, with: &Card.changeset/2)
    |> cast_attachments(attrs, [:card_image, :logo])
    |> validate_required(@required_fields)
    |> validate_slug()
    |> unique_constraint(:name)
  end

  def card_changeset(organization, attrs) do
    organization
    |> cast_attachments(attrs, [:card_image])
    |> cast_embed(:card, with: &Card.changeset/2)
  end

  def logo_changeset(organization, attrs) do
    organization
    |> cast_attachments(attrs, [:logo])
  end

  @doc """
    An organization changeset for changing the slug.
    It requires the slug to change otherwise an error is added.
  """
  def slug_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:slug])
    |> validate_slug()
    |> case do
      %{changes: %{slug: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :slug, "did not change")
    end
  end

  defp validate_slug(changeset) do
    changeset
    |> validate_required([:slug])
    |> validate_format(:slug, ~r/^[a-zA-Z0-9_.]+$/,
      message:
        gettext("must only contain alphanumeric characters, numbers, underscores and periods")
    )
    |> validate_length(:slug, min: 3, max: 30)
    |> unsafe_validate_unique(:slug, Atomic.Repo)
    |> unique_constraint(:slug)
  end
end
