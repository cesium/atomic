defmodule Atomic.Socials do
  @moduledoc """
  A socials embedded struct schema.
  """
  use Atomic.Schema

  @optional_fields ~w(instagram facebook twitter youtube tiktok website)a

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field :instagram, :string
    field :facebook, :string
    field :twitter, :string
    field :youtube, :string
    field :tiktok, :string
    field :website, :string
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @optional_fields)
  end
end
