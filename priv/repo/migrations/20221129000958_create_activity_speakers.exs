defmodule Atomic.Repo.Migrations.CreateActivitySpeakers do
  use Ecto.Migration

  def change do
    create table(:activity_speakers, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :activity_id, references(:activities, on_delete: :nothing, type: :binary_id)
      add :speaker_id, references(:speakers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
