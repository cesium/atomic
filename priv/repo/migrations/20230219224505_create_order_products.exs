defmodule Atomic.Repo.Migrations.OrdersAndProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      add :quantity, :integer, default: 1
      add :size, :string
      timestamps()
    end

    create index(:orders_products, [:order_id])
    create index(:orders_products, [:product_id])
  end
end
