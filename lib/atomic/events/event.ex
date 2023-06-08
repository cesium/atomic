defmodule Atomic.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Location
  alias Atomic.Events.Enrollment
  alias Atomic.Events.EventOrganization
  @required_fields ~w(name location_id)a

  schema "events" do
    field :name, :string
    field :description, :string
    belongs_to :event_organization, EventOrganization
    embeds_one :location, Location, on_replace: :delete
    has_many :activities, Activity
    has_many :enrollments, Enrollment

    timestamps()
  end

  @doc false
  def changeset(events, attrs) do
    events
    |> cast(attrs, @required_fields)
    |> validate_required([])
  end
end
