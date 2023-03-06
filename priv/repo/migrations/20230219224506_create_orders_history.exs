defmodule Atomic.Repo.Migrations.OrdersHistory do
  use Ecto.Migration

  def change do
    create table(:orders_history, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)
      add :admin_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :status, :string
      timestamps()
    end
  end
end
