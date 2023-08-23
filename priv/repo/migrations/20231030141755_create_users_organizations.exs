defmodule Atomic.Repo.Migrations.CreateUsersOrganizations do
  use Ecto.Migration

  def change do
    create table(:users_organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string, null: false
      add :priority, :integer, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :board_departments_id,
          references(:board_departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
