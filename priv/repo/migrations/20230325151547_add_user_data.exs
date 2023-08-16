defmodule Atomic.Repo.Migrations.AddUserData do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      timestamps()
    end

    alter table(:users) do
      add :course_id, references(:courses, on_delete: :nothing, type: :binary_id), null: true
    end
  end
end
