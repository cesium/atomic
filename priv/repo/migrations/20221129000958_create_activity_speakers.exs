defmodule Atomic.Repo.Migrations.CreateActivityInstructors do
  use Ecto.Migration

  def change do
    create table(:activity_instructors, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :activity_id, references(:activities, on_delete: :nothing, type: :binary_id)

      add :instructor_id, references(:instructors, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
