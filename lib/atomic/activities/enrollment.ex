defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities.Session

  @required_fields ~w(session_id user_id)a
  @optional_fields ~w(present)a

  schema "enrollments" do
    field :present, :boolean, default: false

    belongs_to :session, Session
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
