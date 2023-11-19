defmodule Atomic.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :type, :string, null: false
      add :publish_at, :naive_datetime

      timestamps()
    end

    alter table(:activities) do
      add :post_id, references(:posts, type: :binary_id), null: false
    end

    alter table(:announcements) do
      add :post_id, references(:posts, type: :binary_id), null: false
    end
  end
end
