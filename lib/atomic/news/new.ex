defmodule Atomic.News.New do
  @moduledoc """
  The news that can be published by an organization.
  """
  use Atomic.Schema
  alias Atomic.Organizations.Organization

  @required_fields ~w(title description organization_id)a

  schema "news" do
    field :title, :string
    field :description, :string

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    timestamps()
  end

  @doc false
  def changeset(new, attrs) do
    new
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
