defmodule Atomic.Organizations.Membership do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Organization

  @required_fields ~w(user_id organization_id created_by_id role)a
  @optional_fields ~w(number)a

  @roles ~w(follower member admin owner)a

  @derive {
    Flop.Schema,
    filterable: [:member_name],
    sortable: [:member_name, :inserted_at, :updated_at, :number],
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:desc]
    },
    join_fields: [
      member_name: [binding: :user, field: :name, path: [:user, :name]]
    ]
  }

  schema "memberships" do
    field :number, :integer, read_after_writes: true
    field :role, Ecto.Enum, values: @roles

    belongs_to :created_by, User
    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
