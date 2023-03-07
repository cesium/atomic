defmodule Atomic.Repo.Migrations.CreateCollaboratorDepartments do
  use Ecto.Migration

  def change do
    create table(:collaborator_departments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :collaborator_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :department_id, references(:departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
