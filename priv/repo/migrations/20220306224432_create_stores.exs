defmodule Atomic.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
  end
end
