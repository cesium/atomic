defmodule Atomic.Activities.Speaker do
  @moduledoc """
  The person who speaks and provides the activity
  """
  use Atomic.Schema
  alias Atomic.Activities.Activity
  alias Atomic.Activities.ActivitySpeaker
  alias Atomic.Organizations.Organization

  schema "speakers" do
    field :bio, :string
    field :name, :string

    many_to_many :activities, Activity, join_through: ActivitySpeaker, on_replace: :delete

    belongs_to :organization, Organization, on_replace: :delete_if_exists

    timestamps()
  end

  @doc false
  def changeset(speaker, attrs) do
    speaker
    |> cast(attrs, [:name, :bio, :organization_id])
    |> validate_required([:name, :bio, :organization_id])
  end
end
