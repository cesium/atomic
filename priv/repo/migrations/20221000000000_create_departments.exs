defmodule Atomic.Repo.Migrations.CreateDepartments do
  use Ecto.Migration

  def change do
    create table(:departments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string

      timestamps()
    end
  end
end
