defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities.Session

  schema "activities" do
    field :description, :string
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :title, :string

    has_many :activity_sessions, Session,
      on_delete: :delete_all,
      on_replace: :delete_if_exists,
      foreign_key: :activity_id,
      preload_order: [asc: :start]

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :description, :minimum_entries, :maximum_entries])
    |> cast_assoc(:activity_sessions,
      required: true,
      with: &Session.changeset/2
    )
    |> validate_required([:title, :description, :minimum_entries, :maximum_entries])
  end
end
