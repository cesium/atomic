defmodule Atomic.Repo.Migrations.CreateEventEnrollments do
  use Ecto.Migration

  def change do
    create table(:event_enrollments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :present, :boolean, null: false, default: false

      add :event_id, references(:events, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
