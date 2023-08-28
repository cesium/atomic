defmodule Atomic.Organizations.Organization do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities.Location
  alias Atomic.Organizations.{Announcement, Board, Card, Department, Membership, Partner}
  alias Atomic.Uploaders

  @required_fields ~w(name description)a
  @optional_fields ~w(card_image logo)a

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :card_image, Uploaders.Card.Type
    field :logo, Uploaders.Logo.Type

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
end
