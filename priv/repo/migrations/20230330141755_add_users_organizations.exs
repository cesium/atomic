defmodule Atomic.Repo.Migrations.AddUsersOrganizations do
  use Ecto.Migration

  def change do
    create table(:users_organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :year, :string, null: false
      add :title, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create unique_index(:users_organizations, [:year, :organization_id, :user_id])
  end
end
