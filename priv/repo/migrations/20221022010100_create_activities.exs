defmodule Atomic.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :minimum_entries, :integer
      add :maximum_entries, :integer

      add :department_id, references(:departments, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:activities, [:department_id])
  end
end
