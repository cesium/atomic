defmodule Atomic.Activities.Session do
  @moduledoc """
  Each activity can be divided in multiple Sessions.
  """
  use Atomic.Schema

  alias Atomic.Activities

  alias Atomic.Activities.{
    Activity,
    Enrollment,
    Location,
    SessionDepartment,
    SessionSpeaker,
    Speaker
  }

  alias Atomic.Departments
  alias Atomic.Organizations.Department
  alias Atomic.Uploaders

  @required_fields ~w(start finish minimum_entries maximum_entries activity_id)a
  @optional_fields ~w(delete session_image)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:start],
    default_order: %{
      order_by: [:start],
      order_directions: [:asc]
    }
  }

  schema "sessions" do
    field :start, :naive_datetime
    field :finish, :naive_datetime
    field :session_image, Uploaders.Post.Type
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, virtual: true
    embeds_one :location, Location, on_replace: :delete

    belongs_to :activity, Activity

    field :delete, :boolean, virtual: true

    many_to_many :speakers, Speaker, join_through: SessionSpeaker, on_replace: :delete
    many_to_many :departments, Department, join_through: SessionDepartment, on_replace: :delete

    has_many :enrollments, Enrollment, foreign_key: :session_id

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_attachments(attrs, [:session_image])
    |> validate_required(@required_fields)
    |> validate_dates()
    |> validate_entries_number()
    |> maybe_mark_for_deletion()
    |> maybe_put_departments(attrs)
    |> maybe_put_speakers(attrs)
  end

  def session_image_changeset(session, attrs) do
    session
    |> cast_attachments(attrs, [:session_image])
  end

  defp validate_entries_number(changeset) do
    minimum_entries = get_change(changeset, :minimum_entries)
    maximum_entries = get_change(changeset, :maximum_entries)

    if minimum_entries > maximum_entries do
      add_error(
        changeset,
        :maximum_entries,
        gettext("must be greater than minimum entries")
      )
    else
      changeset
    end
  end

  defp validate_dates(changeset) do
    start = get_change(changeset, :start)
    finish = get_change(changeset, :finish)

    if start && finish && Date.compare(start, finish) == :gt do
      add_error(changeset, :finish, gettext("must be after starting date"))
    else
      changeset
    end
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
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
