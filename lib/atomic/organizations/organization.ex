defmodule Atomic.Organizations.Organization do
  use Atomic.Schema
  alias Atomic.Accounts.User
  alias Atomic.Activities.Location
  alias Atomic.Organizations.Department
  alias Atomic.Organizations.Membership
  alias Atomic.Organizations.Partner

  @required_fields ~w(name description)a
  @optional_fields []

  schema "organizations" do
    field :name, :string
    field :description, :string

    has_many :departments, Department,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :organization_id,
      preload_order: [asc: :name]

    has_many :partners, Partner,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :organization_id,
      preload_order: [asc: :name]

    many_to_many :users, User, join_through: Membership

    embeds_one :location, Location, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_location()
  end

  defp validate_location(changeset) do
    changeset
    |> cast_embed(:location, with: &Location.changeset/2)
  end
end
