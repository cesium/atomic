defmodule Atomic.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :cycle, :string, null: false

      timestamps()
    end

    alter table(:users) do
      add :course_id, references(:courses, type: :binary_id)
    end
  end
end
