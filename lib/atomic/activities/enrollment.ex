defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.Session

  schema "enrollments" do
    field :present, :boolean

    belongs_to :session, Session

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [:session_id, :user_id, :present])
    |> validate_required([:session_id, :user_id])
    |> validate_max_entries()
  end

  @doc """
    Validates if the maximum number of enrollments has been reached.
  """
  def validate_max_entries(changeset) do
    sesion_id = get_field(changeset, :session_id)
    session = Activities.get_session!(sesion_id)
    enrolled = Activities.get_total_enrolled(session.id)

    if session.maximum_entries <= enrolled do
      add_error(changeset, :session_id, "Maximum number of enrollments reached.")
    else
      changeset
    end
  end
end
