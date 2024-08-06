defmodule Atomic.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :role, :string, null: false

      add :user_id, references(:users, type: :binary_id), null: false
      add :organization_id, references(:organizations, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:memberships, [:user_id, :organization_id])
  end
end
