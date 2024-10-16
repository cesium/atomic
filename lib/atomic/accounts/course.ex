defmodule Atomic.Accounts.Course do
  @moduledoc """
  A course the user is enrolled in.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User

  @required_fields ~w(name cycle)a
  @cycles ~w(Bachelors Masters PhD)a

  schema "courses" do
    field :name, :string
    field :cycle, Ecto.Enum, values: @cycles

    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
