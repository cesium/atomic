defmodule Atomic.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime
      add :finish, :utc_datetime
      add :location, :map
      add :minimum_entries, :integer
      add :maximum_entries, :integer
      add :session_image, :string

      add :activity_id,
          references(:activities, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:sessions, [:activity_id])

    create constraint(:sessions, :minimum_entries_lower_than_maximum_entries,
             check: "minimum_entries < maximum_entries"
           )
  end
end
