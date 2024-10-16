defmodule Atomic.Organizations.Organization do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Location
  alias Atomic.Organizations.{Announcement, Department, Membership, Partner}
  alias Atomic.Uploaders

  @required_fields ~w(name long_name description)a
  @optional_fields ~w()a

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
    field :long_name, :string
    field :description, :string

    field :logo, Uploaders.Logo.Type
    embeds_one :location, Location, on_replace: :delete

    has_many :departments, Department,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      preload_order: [asc: :name]

    has_many :partners, Partner,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      preload_order: [asc: :name]

    has_many :announcements, Announcement,
      on_replace: :delete,
      preload_order: [asc: :inserted_at]

    many_to_many :users, User, join_through: Membership

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def logo_changeset(organization, attrs) do
    organization
    |> cast_attachments(attrs, [:logo])
  end
end
