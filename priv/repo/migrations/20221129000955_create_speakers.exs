defmodule Atomic.Repo.Migrations.CreateSpeakers do
  use Ecto.Migration

  def change do
    create table(:speakers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :bio, :text

      add :organization_id, references(:organizations, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
  end
end
