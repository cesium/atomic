defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.Session

  @required_fields ~w(session_id user_id)a
  @optional_fields ~w(present)a

  schema "enrollments" do
    field :present, :boolean, default: false

    belongs_to :session, Session
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
    session_id = get_field(changeset, :session_id)
    session = Activities.get_session!(session_id)
    enrolled = Activities.get_total_enrolled(session.id)

    if session.maximum_entries <= enrolled do
      add_error(changeset, :session_id, gettext("maximum number of enrollments reached"))
    else
      changeset
    end
  end
end
