defmodule Atomic.Repo.Migrations.AddUsersOrganizations do
  use Ecto.Migration

  def change do
    create table(:users_organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :string
      add :priority, :integer

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      add :board_departments_id,
          references(:board_departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
