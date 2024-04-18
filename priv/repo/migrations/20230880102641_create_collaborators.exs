defmodule Atomic.Repo.Migrations.CreateCollaborators do
  use Ecto.Migration

  def change do
    create table(:collaborators, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :accepted, :boolean, default: false
      add :accepted_at, :naive_datetime

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :department_id, references(:departments, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create unique_index(:collaborators, [:user_id, :department_id])
  end
end
