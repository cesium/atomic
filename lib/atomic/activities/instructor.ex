defmodule Atomic.Activities.Instructor do
  @moduledoc """
  The person who speaks and provides the activity
  """
  use Atomic.Schema

  schema "instructors" do
    field :bio, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(instructor, attrs) do
    instructor
    |> cast(attrs, [:name, :bio])
    |> validate_required([:name, :bio])
  end
end
