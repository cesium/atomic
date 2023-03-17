defmodule Atomic.Organizations.Association do
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Organization

  @required_fields ~w(accepted user_id organization_id)a
  @optional_fields [:number, :accepted_by_id]

  schema "associations" do
    field :number, :integer, read_after_writes: true
    field :accepted, :boolean, default: false

    belongs_to :accepted_by, User
    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
