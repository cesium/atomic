defmodule Atomic.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string
      add :image, :string
      add :state, :string, default: "active"

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:partners, [:organization_id])
    create unique_index(:partners, [:name])
  end
end
