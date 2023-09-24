defmodule Atomic.Organizations.Announcement do
  @moduledoc """
  An announcement that can be published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Organizations.Organization

  @required_fields ~w(title description content publish_at organization_id)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:publish_at],
    default_order: %{
      order_by: [:publish_at],
      order_directions: [:desc]
    }
  }

  schema "announcements" do
    field :title, :string
    field :description, :string
    field :content, :map
    field :publish_at, :naive_datetime

    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(announcements, attrs) do
    announcements
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
