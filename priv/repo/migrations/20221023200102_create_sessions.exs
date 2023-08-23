defmodule Atomic.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :naive_datetime, null: false
      add :finish, :naive_datetime, null: false
      add :location, :map
      add :minimum_entries, :integer, null: false
      add :maximum_entries, :integer, null: false
      add :session_image, :string

      add :activity_id, references(:activities, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:sessions, [:activity_id])
  end
end
