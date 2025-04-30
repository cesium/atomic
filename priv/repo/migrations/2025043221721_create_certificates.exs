defmodule Atomic.Repo.Migrations.CreateCertificates do
  use Ecto.Migration

  def change do
    create table(:certificates, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :background, :boolean, default: false, null: false
      add :title, :integer
      add :content, :text
      add :organization, :boolean, default: false, null: false
      add :background_color, :string
      add :title_color, :string
      add :content_color, :string
      add :organization_color, :string
      add :organization_id, references(:organizations, type: :binary_id), null: false

      timestamps()
    end

    create index(:certificates, [:organization_id])

    alter table(:organizations) do
      add :certificate_template, references(:certificates, type: :binary_id), null: true
    end
  end
end
