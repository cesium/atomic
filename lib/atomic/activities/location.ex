defmodule Atomic.Activities.Location do
  @moduledoc """
  An activity location embedded struct schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name]
  @optional_fields [:url]

  @primary_key false
  embedded_schema do
    field :name
    field :url, :string
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
