defmodule Atomic.Organizations.UserOrganization do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.BoardDepartments

  @required_fields ~w(role priority user_id board_departments_id)a

  schema "users_organizations" do
    field :role, :string
    field :priority, :integer

    belongs_to :user, User
    belongs_to :board_departments, BoardDepartments

    timestamps()
  end

  @doc false
  def changeset(user_organization, attrs) do
    user_organization
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
