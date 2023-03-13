defmodule Atomic.Repo.Migrations.AddAssociations do
  use Ecto.Migration

  def change do
    create table(:associations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :integer
      add :accepted, :boolean, null: false, default: false
      add :accepted_by_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:associations, [:user_id, :organization_id])
    create unique_index(:associations, [:number, :organization_id])
  end
end
