defmodule Atomic.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:board, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :year, :string, null: false
      add :organization_id, references(:organizations, type: :binary_id, null: false)
      timestamps()
    end

    create unique_index(:board, [:year, :organization_id])
  end
end
