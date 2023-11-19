defmodule Atomic.Repo.Migrations.CreatePosts do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :type, :string, null: false

      timestamps()
    end

    create index(:posts, [:inserted_at])

    alter table(:activities) do
      add :post_id, references(:posts, type: :binary_id), null: false
    end

    alter table(:announcements) do
      add :post_id, references(:posts, type: :binary_id), null: false
    end
  end
end
