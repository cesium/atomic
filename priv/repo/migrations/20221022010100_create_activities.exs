defmodule Atomic.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :description, :text, null: false
      add :start, :naive_datetime, null: false
      add :finish, :naive_datetime, null: false
      add :location, :map
      add :minimum_entries, :integer, null: false
      add :maximum_entries, :integer, null: false
      add :internal, :boolean, null: false
      add :image, :string

      add :event_id, references(:events, type: :binary_id)
      add :organization_id, references(:organizations, type: :binary_id), null: false

      timestamps()
    end
  end
end
