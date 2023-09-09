defmodule Atomic.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :integer
      add :role, :string, null: false

      add :created_by_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create unique_index(:memberships, [:user_id, :organization_id])
    create unique_index(:memberships, [:number, :organization_id])
  end
end
