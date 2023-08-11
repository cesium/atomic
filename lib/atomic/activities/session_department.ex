defmodule Atomic.Activities.SessionDepartment do
  @moduledoc """
    An activity department
  """
  use Atomic.Schema

  alias Atomic.Activities.Session
  alias Atomic.Organizations.Department

  @required_fields ~w(session_id department_id)a

  schema "session_departments" do
    belongs_to :session, Session
    belongs_to :department, Department

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
