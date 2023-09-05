defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.Activity

  @required_fields ~w(activity_id user_id)a
  @optional_fields ~w(present)a

  schema "enrollments" do
    field :present, :boolean, default: false

    belongs_to :activity, Activity
    belongs_to :user, User

    timestamps()
  end

  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_maximum_entries()
    |> validate_required(@required_fields)
  end

  def update_changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  # Validates if the maximum number of enrollments has been reached.
  defp validate_maximum_entries(changeset) do
    activity_id = get_field(changeset, :activity_id)
    activity = Activities.get_activity!(activity_id)
    enrolled = Activities.get_total_enrolled(activity.id)

    if activity.maximum_entries <= enrolled do
      add_error(changeset, :activity_id, gettext("maximum number of enrollments reached"))
    else
      changeset
    end
  end
end
