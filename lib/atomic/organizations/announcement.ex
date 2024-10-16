defmodule Atomic.Organizations.Announcement do
  @moduledoc """
  An announcement created and published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Feed.Post
  alias Atomic.Organizations.Organization

  @required_fields ~w(title description organization_id)a
  @optional_fields ~w()a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:inserted_at],
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:desc]
    }
  }

  schema "announcements" do
    field :title, :string
    field :description, :string
    field :image, Uploaders.Post.Type

    belongs_to :organization, Organization
    belongs_to :post, Post, foreign_key: :post_id

    timestamps()
  end

  def changeset(announcements, attrs) do
    announcements
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def image_changeset(announcement, attrs) do
    announcement
    |> cast_attachments(attrs, [:image])
  end
end
