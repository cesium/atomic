defmodule Atomic.Activities.Speaker do
  @moduledoc """
  The person who speaks and provides the activity
  """
  use Atomic.Schema

  alias Atomic.Activities

  schema "speakers" do
    field :bio, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(speaker, attrs) do
    speaker
    |> cast(attrs, [:name, :bio])
    |> validate_required([:name, :bio])
  end
end
