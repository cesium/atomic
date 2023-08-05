defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
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
  end
end
