defmodule Atomic.Activites.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activies" do
    field :capacity, :integer
    field :date, :utc_datetime
    field :description, :string
    field :location, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :description, :date, :capacity, :location])
    |> validate_required([:title, :description, :date, :capacity, :location])
  end
end
