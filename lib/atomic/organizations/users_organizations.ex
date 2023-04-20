defmodule Atomic.Organizations.UserOrganization do
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Organization
  alias Atomic.Ecto.Year

  @required_fields ~w(year title user_id organization_id)a

  schema "users_organizations" do
    field :year, Year
    field :title, :string

    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(user_organization, attrs) do
    user_organization
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
