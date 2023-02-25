defmodule Atomic.Activities.ActivityInstructor do
  @moduledoc """
    An activity instructor
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Instructor

  @required_fields ~w(activity_id instructor_id)a

  schema "activity_instructors" do
    belongs_to :activity, Activity
    belongs_to :instructor, Instructor

    timestamps()
  end

  def changeset(activity_instructors, attrs) do
    activity_instructors
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(activity_instructors, attrs) do
    activity_instructors
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
