defmodule Atomic.Activities.Activity do
  @moduledoc """
  An activity created and published by an organization.
  """
  use Atomic.Schema

  alias Atomic.Activities.Enrollment
  alias Atomic.Feed.Post
  alias Atomic.Location
  alias Atomic.Organizations.Organization

  @required_fields ~w(title description start finish enrolled organization_id)a
  @optional_fields ~w(maximum_entries)a

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

    field :maximum_entries, :integer, default: nil
    field :enrolled, :integer, default: 0

    field :card, Uploaders.Post.Type
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
    |> validate_enrollments()
    |> maybe_mark_for_deletion()
  end

  def image_changeset(activity, attrs) do
    activity
    |> cast_attachments(attrs, [:card])
  end

  defp validate_dates(changeset) do
    start = get_field(changeset, :start)
    finish = get_field(changeset, :finish)

    is_new_record = is_nil(changeset.data.id)

    if is_new_record do
      changeset
      |> validate_finish_after_start(start, finish)
      |> validate_start_in_future(start)
    else
      changeset
      |> validate_finish_after_start(start, finish)
    end
  end

  defp validate_finish_after_start(changeset, start, finish)
       when not is_nil(start) and not is_nil(finish) do
    if NaiveDateTime.compare(start, finish) == :gt do
      add_error(changeset, :finish, gettext("must be after starting date"))
    else
      changeset
    end
  end

  defp validate_finish_after_start(changeset, _start, _finish), do: changeset

  defp validate_start_in_future(changeset, start) when not is_nil(start) do
    if NaiveDateTime.compare(start, NaiveDateTime.utc_now()) in [:lt, :eq] do
      add_error(changeset, :start, gettext("must be in the future"))
    else
      changeset
    end
  end

  defp validate_start_in_future(changeset, _start), do: changeset

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

  def validate_enrollments_values(_enrolled, nil, changeset), do: changeset

  def validate_enrollments_values(enrolled, maximum_entries, changeset) do
    if enrolled > maximum_entries do
      add_error(changeset, :maximum_entries, gettext("maximum number of enrollments reached"))
    else
      changeset
    end
  end
end
