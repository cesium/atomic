defmodule Atomic.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :description, :text, null: false
      add :image, :string

      add :organization_id, references(:organizations, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end
  end
end
