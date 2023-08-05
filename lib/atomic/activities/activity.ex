defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities
  alias Atomic.Activities.ActivityDepartment
  alias Atomic.Activities.ActivitySpeaker
  alias Atomic.Activities.Session
  alias Atomic.Activities.Speaker
  alias Atomic.Departments
  alias Atomic.Events.Event
  alias Atomic.Organizations.Department

  @required_fields ~w(title description
                    minimum_entries maximum_entries)a

  @optional_fields ~w(event_id)a

  schema "activities" do
    field :title, :string
    field :description, :string
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, virtual: true

    many_to_many :speakers, Speaker, join_through: ActivitySpeaker, on_replace: :delete

    many_to_many :departments, Department, join_through: ActivityDepartment, on_replace: :delete

    has_many :activity_sessions, Session,
      on_delete: :delete_all,
      on_replace: :delete_if_exists,
      foreign_key: :activity_id,
      preload_order: [asc: :start]

    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:activity_sessions,
      required: true,
      with: &Session.changeset/2
    )
    |> maybe_put_departments(attrs)
    |> maybe_put_speakers(attrs)
    |> validate_required(@required_fields)
  end

  defp maybe_put_departments(changeset, attrs) do
    if attrs["departments"] do
      departments = Departments.get_departments(attrs["departments"])

      Ecto.Changeset.put_assoc(changeset, :departments, departments)
    else
      changeset
    end
  end

  defp maybe_put_speakers(changeset, attrs) do
    if attrs["speakers"] do
      speakers = Activities.get_speakers(attrs["speakers"])

      Ecto.Changeset.put_assoc(changeset, :speakers, speakers)
    else
      changeset
    end
  end
end
