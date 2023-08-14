defmodule Atomic.Repo.Migrations.CreatePartnerships do
  use Ecto.Migration

  def change do
    create table(:partnerships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string
      add :image, :string

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:partnerships, [:organization_id])
    create unique_index(:partnerships, [:name])
  end
end
