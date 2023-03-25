defmodule Atomic.Repo.Migrations.AddUserData do
  use Ecto.Migration

  def change do
    create table(:majors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    alter table(:users) do
      add :name, :string, null: false
      add :major_id, references(:majors, on_delete: :nothing, type: :binary_id)
    end
  end
end
