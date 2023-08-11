defmodule Atomic.Repo.Migrations.CreateSessionDepartments do
  use Ecto.Migration

  def change do
    create table(:session_departments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :session_id, references(:sessions, on_delete: :nothing, type: :binary_id)

      add :department_id, references(:departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
