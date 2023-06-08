defmodule Atomic.Events.Enrollment do
  @moduledoc """
  An event enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Events.Event

  schema "enrollments" do
    field :present, :boolean
    belongs_to :event, Event
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [:event_id, :user_id, :present])
    |> validate_required([:event_id, :user_id])
  end
end
