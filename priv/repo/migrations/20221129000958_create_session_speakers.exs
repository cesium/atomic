defmodule Atomic.Repo.Migrations.CreateSessionSpeakers do
  use Ecto.Migration

  def change do
    create table(:session_speakers, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :session_id, references(:sessions, on_delete: :nothing, type: :binary_id)
      add :speaker_id, references(:speakers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
