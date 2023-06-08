defmodule Atomic.Events.EventOrganization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Atomic.Events.Event
  alias Atomic.Organizations.Organization

  schema "event_organizations" do
    belongs_to :event, Event
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(event_organization, attrs) do
    event_organization
    |> cast(attrs, [:event_id, :organization_id])
    |> validate_required([])
  end
end
