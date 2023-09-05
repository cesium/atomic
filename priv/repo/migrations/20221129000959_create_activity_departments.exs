defmodule Atomic.Repo.Migrations.CreateActivityDepartments do
  use Ecto.Migration

  def change do
    create table(:activity_departments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :activity_id, references(:activities, on_delete: :nothing, type: :binary_id)
      add :department_id, references(:departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
