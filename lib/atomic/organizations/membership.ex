defmodule Atomic.Organizations.Membership do
  @moduledoc """
  Schema representing a user's membership in an organization.

  Memberships are used to track the relationship between a user and an organization.

  Types of memberships:
    * `owner` - The user has full control over the organization.
    * `admin` - The user can control the organization's departments, activities and partners.
    * `follower` - The user is following the organization.

  This schema can be further extended to include additional roles, such as `member` (with even different denominations).
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Organization

  @required_fields ~w(user_id organization_id role)a
  @optional_fields ~w()a

  @roles ~w(follower admin owner)a

  schema "memberships" do
    field :role, Ecto.Enum, values: @roles

    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> prepare_changes(&maybe_increment_follower_count/1)
  end

  defp maybe_increment_follower_count(changeset) do
    organization_id = get_change(changeset, :organization_id)
    role = get_change(changeset, :role)

    if organization_id && role && role == :follower do
      query = from Organization, where: [id: ^organization_id]
      changeset.repo.update_all(query, inc: [follower_count: 1])
    end

    changeset
  end

  def roles, do: @roles
end
