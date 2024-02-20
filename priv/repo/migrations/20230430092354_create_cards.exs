defmodule Atomic.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :card_image, :string
      add :card, :map, default: %{}, null: true
    end
  end
end
