defmodule Atomic.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime
      add :finish, :utc_datetime
      add :location, :map

      add :activity_id,
          references(:activities, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:sessions, [:activity_id])
  end
end
