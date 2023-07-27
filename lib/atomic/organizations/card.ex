defmodule Atomic.Organizations.Card do
  @moduledoc """
  The membership card for an organization
  """
  use Atomic.Schema
  import Ecto.Changeset

  @optional_fields [
    :name_size,
    :name_color,
    :name_x,
    :name_y,
    :number_size,
    :number_color,
    :number_x,
    :number_y
  ]

  @primary_key false
  embedded_schema do
    field :name_size, :float
    field :name_color, :string
    field :name_x, :float
    field :name_y, :float
    field :number_size, :float
    field :number_color, :string
    field :number_x, :float
    field :number_y, :float
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, @optional_fields)
  end
end
