defmodule Atomic.Feed.Post do
  @moduledoc """
  A post published in the feed. Can either be an announcement or an activity.
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Organizations.Announcement

  @types ~w(activity announcement)a

  @required_fields ~w(type)a

  schema "posts" do
    field :type, Ecto.Enum, values: @types

    has_one :activity, Activity
    has_one :announcement, Announcement

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
