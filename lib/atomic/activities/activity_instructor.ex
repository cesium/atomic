defmodule Atomic.Activities.ActivitySpeaker do
  @moduledoc """
    An activity speaker
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Speaker

  @required_fields ~w(activity_id speaker_id)a

  schema "activity_speakers" do
    belongs_to :activity, Activity
    belongs_to :speaker, Speaker

    timestamps()
  end

  def changeset(activity_speakers, attrs) do
    activity_speakers
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(activity_speakers, attrs) do
    activity_speakers
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
