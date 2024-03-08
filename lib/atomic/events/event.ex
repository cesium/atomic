defmodule Atomic.Events.Event do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Location
  alias Atomic.Events.EventEnrollment
  alias Atomic.Events.EventOrganization

  @required_fields ~w(name location_id)a
  @optional_fields ~w(description event_organization_id)a

  schema "events" do
    field :name, :string
    field :description, :string

    belongs_to :event_organization, EventOrganization
    embeds_one :location, Location, on_replace: :delete

    has_many :activities, Activity
    has_many :enrollments, EventEnrollment

    timestamps()
  end

  def changeset(events, attrs) do
    events
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
