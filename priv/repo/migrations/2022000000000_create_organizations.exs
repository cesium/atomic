defmodule Atomic.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text, null: false
      add :location, :map
      add :logo, :string
      timestamps()
    end

    create unique_index(:organizations, [:name])
  end
end
