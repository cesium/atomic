defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities.Enrollment
  alias Atomic.Activities.Session
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
    |> validate_required(@required_fields)
  end
end
