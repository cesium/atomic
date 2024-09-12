defmodule Atomic.Location do
  @moduledoc """
  A location embedded struct schema.
  """
  use Atomic.Schema

  @required_fields ~w(name address)a
  @optional_fields ~w()a

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field :name, :string
    field :address, :string
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
