defmodule Atomic.Repo.Migrations.CreateBoardDepartments do
  use Ecto.Migration

  def change do
    create table(:board_departments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :priority, :integer
      add :board_id, references(:board, type: :binary_id, null: false)

      timestamps()
    end
  end
end
