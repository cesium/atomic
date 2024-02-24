defmodule Atomic.Organizations.Collaborator do
  @moduledoc """
    A relation representing an organization department collaborator.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Department

  @required_fields ~w(user_id department_id)a
  @optional_fields ~w(accepted)a

  @derive {
    Flop.Schema,
    default_limit: 7,
    filterable: [:accepted],
    sortable: [:collaborator_name, :inserted_at, :updated_at],
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:desc]
    },
    join_fields: [
      collaborator_name: [binding: :user, field: :name, path: [:user, :name]]
    ]
  }

  schema "collaborators" do
    belongs_to :user, User
    belongs_to :department, Department

    field :accepted, :boolean, default: false

    timestamps()
  end

  def changeset(collaborator_departments, attrs) do
    collaborator_departments
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
