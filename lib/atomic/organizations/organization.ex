defmodule Atomic.Organizations.Organization do
  @moduledoc false
  use Atomic.Schema
  alias Atomic.Accounts.User
  alias Atomic.Activities.Location
  alias Atomic.Departments.Department
  alias Atomic.Organizations.Card
  alias Atomic.Organizations.Membership
  alias Atomic.Partnerships.Partner
  alias Atomic.Uploaders

  @required_fields ~w(name description)a
  @optional_fields []

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :card_image, Uploaders.Card.Type

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

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_attachments(attrs, [:card_image])
    |> validate_location()
    |> validate_card()
  end

  defp validate_location(changeset) do
    changeset
    |> cast_embed(:location, with: &Location.changeset/2)
  end

  defp validate_card(changeset) do
    changeset
    |> cast_embed(:card, with: &Card.changeset/2)
  end

  def card_changeset(organization, attrs) do
    organization
    |> cast_attachments(attrs, [:card_image])
    |> validate_card()
  end
end
