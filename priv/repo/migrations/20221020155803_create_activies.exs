defmodule Atomic.Repo.Migrations.CreateActivies do
  use Ecto.Migration

  def change do
    create table(:activies) do
      add :title, :string
      add :description, :text
      add :date, :utc_datetime
      add :capacity, :integer
      add :location, :string

      timestamps()
    end
  end
end
