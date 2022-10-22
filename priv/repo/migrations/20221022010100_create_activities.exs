defmodule Atomic.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :string
      add :description, :text
      add :minimum_entries, :integer
      add :maximum_entries, :integer

      timestamps()
    end
  end
end
