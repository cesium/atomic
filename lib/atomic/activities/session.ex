defmodule Atomic.Activities.Session do
  @moduledoc """
  Each activity can be divided in multiple Sessions.
  """
  use Atomic.Schema

  alias Eegs.Activities.Activity

  schema "sessions" do
    field :finish, :naive_datetime
    field :start, :naive_datetime

    field :delete, :boolean, virtual: true

    belongs_to :activity, Activity

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:start, :finish, :delete])
    |> validate_required([:start, :finish])
    |> maybe_mark_for_deletion()
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
