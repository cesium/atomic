defmodule Atomic.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :description, :text

      add :collaborator_applications, :boolean, default: false, null: false
      add :archived, :boolean, default: false, null: false

      add :banner, :string

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:departments, [:organization_id])
  end
end
