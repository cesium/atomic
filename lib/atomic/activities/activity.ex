defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities
  alias Atomic.Activities.ActivityDepartment
  alias Atomic.Activities.ActivityInstructor
  alias Atomic.Activities.Enrollment
  alias Atomic.Activities.Session
  alias Atomic.Activities.Instructor
  alias Atomic.Organizations
  alias Atomic.Organizations.Department
  @required_fields ~w(title description
                    minimum_entries maximum_entries)a

  @optional_fields []

  schema "activities" do
    field :title, :string
    field :description, :string
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, virtual: true

    many_to_many :instructors, Instructor, join_through: ActivityInstructor, on_replace: :delete

    many_to_many :departments, Department, join_through: ActivityDepartment, on_replace: :delete

    has_many :activity_sessions, Session,
      on_delete: :delete_all,
      on_replace: :delete_if_exists,
      foreign_key: :activity_id,
      preload_order: [asc: :start]

    has_many :enrollments, Enrollment, foreign_key: :activity_id

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
    |> maybe_put_instructors(attrs)
    |> validate_required(@required_fields)
  end

  defp maybe_put_departments(changeset, attrs) do
    if attrs["departments"] do
      departments = Organizations.get_departments(attrs["departments"])

      Ecto.Changeset.put_assoc(changeset, :departments, departments)
    else
      changeset
    end
  end

  defp maybe_put_instructors(changeset, attrs) do
    if attrs["instructors"] do
      instructors = Activities.get_instructors(attrs["instructors"])

      Ecto.Changeset.put_assoc(changeset, :instructors, instructors)
    else
      changeset
    end
  end
end
