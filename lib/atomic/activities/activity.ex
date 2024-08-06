defmodule Atomic.Activities.Activity do
  @moduledoc """
  An activity created and published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Activities.Enrollment
  alias Atomic.Feed.Post
  alias Atomic.Location
  alias Atomic.Organizations.Organization

  @required_fields ~w(title description start finish minimum_entries maximum_entries enrolled organization_id)a
  @optional_fields ~w()a

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

    field :maximum_entries, :integer
    field :minimum_entries, :integer
    field :enrolled, :integer, default: 0

    field :image, Uploaders.Post.Type
    embeds_one :location, Location, on_replace: :update

    belongs_to :organization, Organization
    belongs_to :post, Post

    has_many :enrollments, Enrollment

    timestamps()
  end

  def changeset(activity, attrs \\ %{}) do
    activity
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:location, with: &Location.changeset/2)
    |> validate_required(@required_fields)
    |> validate_dates()
    |> validate_entries()
    |> validate_enrollments()
    |> check_constraint(:enrolled, name: :enrolled_less_than_max)
    |> maybe_mark_for_deletion()
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

    case {enrolled, maximum_entries} do
      {nil, nil} ->
        validate_enrollments_values(
          changeset.data.enrolled,
          changeset.data.maximum_entries,
          changeset
        )

      {nil, maximum} ->
        validate_enrollments_values(changeset.data.enrolled, maximum, changeset)

      {enrolled, nil} ->
        validate_enrollments_values(enrolled, changeset.data.maximum_entries, changeset)

      {enrolled, maximum} ->
        validate_enrollments_values(enrolled, maximum, changeset)
    end
  end

  def validate_enrollments_values(enrolled, maximum_entries, changeset) do
    if enrolled > maximum_entries do
      add_error(changeset, :maximum_entries, gettext("maximum number of enrollments reached"))
    else
      changeset
    end
  end
end
