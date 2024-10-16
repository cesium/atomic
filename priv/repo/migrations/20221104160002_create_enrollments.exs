defmodule Atomic.Repo.Migrations.CreateEnrollments do
  use Ecto.Migration

  def change do
    create table(:enrollments, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :present, :boolean, null: false, default: false

      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
