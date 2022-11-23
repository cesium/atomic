defmodule Atomic.Repo.Migrations.CreatePartnerships do
  use Ecto.Migration

  def change do
    create table(:partnerships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :image, :string
      timestamps()
    end
  end
end
