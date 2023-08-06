defmodule Atomic.Repo.Migrations.News do
  use Ecto.Migration

  def change do
    create table(:news, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :string, null: false
      add :description, :string, null: false

      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end
  end
end
