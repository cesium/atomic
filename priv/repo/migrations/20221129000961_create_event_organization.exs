defmodule Atomic.Repo.Migrations.CreateEventOrganization do
  use Ecto.Migration

  def change do
    create table(:event_organization, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id)
      add :event_id, references(:events, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
