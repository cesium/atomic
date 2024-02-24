defmodule Atomic.Activities.Activity do
  @moduledoc """
  An activity created and published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Activities

  alias Atomic.Activities.{
    ActivityEnrollment,
    ActivitySpeaker,
    Location,
    Speaker
  }

  alias Atomic.Events.Event
  alias Atomic.Feed.Post
  alias Atomic.Organizations.Organization

  @required_fields ~w(title description start finish minimum_entries maximum_entries organization_id enrolled)a
  @optional_fields ~w(event_id image)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:start],
    default_order: %{
      order_by: [:start],
      order_directions: [:asc]
    }
  }

  schema "activities" do
    field :title, :string
    field :description, :string
    field :start, :naive_datetime
    field :finish, :naive_datetime
    field :image, Uploaders.Post.Type
    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, default: 0

    embeds_one :location, Location, on_replace: :update

    belongs_to :organization, Organization
    belongs_to :event, Event
    belongs_to :post, Post, foreign_key: :post_id

    many_to_many :speakers, Speaker, on_replace: :delete, join_through: ActivitySpeaker
    has_many :activity_enrollments, ActivityEnrollment, foreign_key: :activity_id

    timestamps()
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
    |> validate_dates()
    |> validate_entries()
    |> validate_enrollments()
    |> maybe_mark_for_deletion()
    |> maybe_put_speakers(attrs)
  end

  def image_changeset(activity, attrs) do
    activity
    |> cast_attachments(attrs, [:image])
  end

  defp validate_entries(changeset) do
    minimum_entries = get_change(changeset, :minimum_entries)
    maximum_entries = get_change(changeset, :maximum_entries)

    case {minimum_entries, maximum_entries} do
      {nil, nil} ->
        validate_entries_values(
          changeset.data.minimum_entries,
          changeset.data.maximum_entries,
          changeset
        )

      {nil, maximum} ->
        validate_entries_values(changeset.data.minimum_entries, maximum, changeset)

      {minimum, nil} ->
        validate_entries_values(minimum, changeset.data.maximum_entries, changeset)

      {min, max} ->
        validate_entries_values(min, max, changeset)
    end
  end

  def validate_entries_values(min_value, max_value, changeset) do
    if min_value > max_value do
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

  def validate_enrollments(changeset) do
    enrolled = get_change(changeset, :enrolled)
    maximum_entries = get_change(changeset, :maximum_entries)

    if maximum_entries < enrolled do
      add_error(changeset, :maximum_entries, gettext("maximum number of enrollments reached"))
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
