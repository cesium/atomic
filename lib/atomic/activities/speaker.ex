defmodule Atomic.Activities.Speaker do
  @moduledoc """
  The person who speaks and provides the activity
  """
  use Atomic.Schema
  alias Atomic.Activities.Activity
  alias Atomic.Activities.SessionSpeaker
  alias Atomic.Organizations.Organization

  @required_fields ~w(name bio organization_id)a

  schema "speakers" do
    field :bio, :string
    field :name, :string

    many_to_many :activities, Activity, join_through: SessionSpeaker, on_replace: :delete

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    timestamps()
  end

  @doc false
  def changeset(speaker, attrs) do
    speaker
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
