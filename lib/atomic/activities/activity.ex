defmodule Atomic.Activities.Activity do
  @moduledoc """
    An activity
  """
  use Atomic.Schema

  alias Atomic.Activities

  alias Atomic.Activities.{
    ActivityDepartment,
    ActivitySpeaker,
    Enrollment,
    Location,
    Speaker
  }

  alias Atomic.Departments
  alias Atomic.Events.Event
  alias Atomic.Organizations.Department
  alias Atomic.Uploaders

  @required_fields ~w(title description start finish minimum_entries maximum_entries)a
  @optional_fields ~w(event_id image)a

  schema "activities" do
    field :title, :string
    field :description, :string

    field :start, :naive_datetime
    field :finish, :naive_datetime
    field :image, Uploaders.Post.Type
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, virtual: true
    embeds_one :location, Location, on_replace: :delete

    many_to_many :speakers, Speaker, join_through: ActivitySpeaker, on_replace: :delete
    many_to_many :departments, Department, join_through: ActivityDepartment, on_replace: :delete

    has_many :enrollments, Enrollment, foreign_key: :activity_id

    belongs_to :event, Event

    timestamps()
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
    |> validate_dates()
    |> validate_entries_number()
    |> maybe_mark_for_deletion()
    |> maybe_put_departments(attrs)
    |> maybe_put_speakers(attrs)
  end

  def activity_image_changeset(activity, attrs) do
    activity
    |> cast_attachments(attrs, [:image])
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
