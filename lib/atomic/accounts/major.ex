defmodule Atomic.Accounts.Major do
  @moduledoc """
  A major the user is enrolled in
  """
  use Atomic.Schema

  alias Atomic.Accounts.User

  @required_fields ~w(name)a

  schema "majors" do
    field :name, :string
    has_many :users, User

    timestamps()
  end

  def changeset(major, attrs) do
    major
    |> cast(attrs, @required_fields)
  end
end
