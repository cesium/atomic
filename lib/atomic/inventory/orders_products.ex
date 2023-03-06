defmodule Atomic.Inventory.OrdersProducts do
  use Atomic.Schema
  alias Atomic.Inventory.Product
  alias Atomic.Inventory.Order

  schema "orders_products" do
    belongs_to :order, Order
    belongs_to :product, Product
    field :quantity, :integer, default: 1
    field :size, Ecto.Enum, values: ~w(XS S M L XL XXL)a
    timestamps()
  end

  @doc false
  def changeset(orders_products, attrs) do
    orders_products
    |> cast(attrs, [:order_id, :product_id, :quantity, :size])
    |> validate_required([:order_id, :product_id, :quantity, :size])
  end
end
