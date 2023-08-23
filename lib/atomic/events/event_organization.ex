defmodule Atomic.Events.EventOrganization do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Events.Event
  alias Atomic.Organizations.Organization

  @required_fields ~w(event_id organization_id)a

  schema "event_organizations" do
    belongs_to :event, Event
    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(event_organization, attrs) do
    event_organization
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
