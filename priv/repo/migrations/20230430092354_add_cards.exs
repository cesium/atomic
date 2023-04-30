defmodule Atomic.Repo.Migrations.AddCards do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :card, :string
    end
  end
end
