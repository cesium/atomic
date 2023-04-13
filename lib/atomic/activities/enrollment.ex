defmodule Atomic.Activities.Enrollment do
  @moduledoc """
  An activity enrollment.
  """
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity

  schema "enrollments" do

    field :present, :boolean

    belongs_to :activity, Activity

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, [:activity_id, :user_id, :present])
    |> validate_required([:activity_id, :user_id])
  end
end
