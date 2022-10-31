defmodule Atomic.Activities.Session do
  @moduledoc """
  Each activity can be divided in multiple Sessions.
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Location

  @required_fields ~w(start finish)a
  @optional_fields ~w(delete)a

  schema "sessions" do
    field :start, :naive_datetime
    field :finish, :naive_datetime

    embeds_one :location, Location, on_replace: :delete

    field :delete, :boolean, virtual: true

    belongs_to :activity, Activity

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_location()
    |> maybe_mark_for_deletion()
  end

  defp validate_location(changeset) do
    changeset
    |> cast_embed(:location, with: &Location.changeset/2)
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
