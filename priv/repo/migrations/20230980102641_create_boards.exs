defmodule Atomic.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :year, :string, null: false

      add :organization_id, references(:organizations, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:boards, [:year, :organization_id])
  end
end
