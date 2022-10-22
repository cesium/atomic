defmodule Atomic.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :description, :string
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :description, :minimum_entries, :maximum_entries])
    |> validate_required([:title, :description, :minimum_entries, :maximum_entries])
  end
end
