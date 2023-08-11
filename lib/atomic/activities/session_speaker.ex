defmodule Atomic.Activities.SessionSpeaker do
  @moduledoc """
    An activity speaker
  """
  use Atomic.Schema

  alias Atomic.Activities.Session
  alias Atomic.Activities.Speaker

  @required_fields ~w(session_id speaker_id)a

  schema "session_speakers" do
    belongs_to :session, Session
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
