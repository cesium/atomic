defmodule Atomic.Repo.Migrations.CreateBoardDepartments do
  use Ecto.Migration

  def change do
    create table(:board_departments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :priority, :integer, null: false

      add :board_id, references(:boards, type: :binary_id), null: false

      timestamps()
    end
  end
end
