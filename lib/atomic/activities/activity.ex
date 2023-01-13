defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities
  alias Atomic.Activities.ActivitySpeaker
  alias Atomic.Activities.Enrollment
  alias Atomic.Activities.Session
  alias Atomic.Activities.Speaker
  alias Atomic.Departments.Department

  @required_fields ~w(title description
                    minimum_entries maximum_entries
                    department_id)a

  @optional_fields []

  schema "activities" do
    field :title, :string
    field :description, :string
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, virtual: true

    many_to_many :speakers, Speaker,
      join_through: ActivitySpeaker,
      on_replace: :delete

    belongs_to :department, Department

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
    |> maybe_put_speakers(attrs)
    |> validate_required(@required_fields)
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
