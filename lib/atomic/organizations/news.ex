defmodule Atomic.Organizations.News do
  @moduledoc """
  The news that can be published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Organizations.Organization

  @required_fields ~w(title description organization_id)a

  schema "news" do
    field :title, :string
    field :description, :string

    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(news, attrs) do
    news
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
