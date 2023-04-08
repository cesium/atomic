defmodule Atomic.Accounts.Course do
  @moduledoc """
  A course the user is enrolled in
  """
  use Atomic.Schema

  alias Atomic.Accounts.User

  @required_fields ~w(name)a

  schema "courses" do
    field :name, :string
    has_many :users, User

    timestamps()
  end

  def changeset(course, attrs) do
    course
    |> cast(attrs, @required_fields)
  end
end
