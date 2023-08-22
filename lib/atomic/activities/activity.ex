defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities.Session
  alias Atomic.Events.Event

  @required_fields ~w(title description)a
  @optional_fields ~w(event_id)a

  schema "activities" do
    field :title, :string
    field :description, :string

    has_many :sessions, Session,
      on_delete: :delete_all,
      on_replace: :delete_if_exists,
      foreign_key: :activity_id,
      preload_order: [asc: :start]

    belongs_to :event, Event

    timestamps()
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:sessions)
    |> validate_required(@required_fields)
  end
end
