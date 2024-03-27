defmodule Atomic.Location do
  @moduledoc """
  A location embedded struct schema.
  """
  use Atomic.Schema

  @required_fields ~w(name)a
  @optional_fields ~w(url)a

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field :name, :string
    field :url, :string
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
