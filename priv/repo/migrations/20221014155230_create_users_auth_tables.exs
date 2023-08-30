defmodule Atomic.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :citext, null: false
      add :slug, :citext
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :profile_picture, :string
      add :role, :string, null: false, default: "student"

      add :default_organization_id,
          references(:organizations, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:slug])

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
