defmodule Atomic.Events.Enrollment do
  @moduledoc """
  An event enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Events.Event

  @required_fields ~w(event_id user_id)
  @optional_fields ~w(present)

  schema "enrollments" do
    field :present, :boolean

    belongs_to :event, Event
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
