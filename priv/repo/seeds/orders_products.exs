defmodule Atomic.Repo.Seeds.OrdersProducts do
  alias Atomic.Inventory.OrdersProducts
  alias Atomic.Repo
  alias Atomic.Inventory

  def run do
    seed_order_product()
  end

  def seed_order_product do
    case Repo.all(OrdersProducts) do
      [] ->
        generate_order_product(10)
        |> Enum.each(&insert_orders_products/1)

      _ ->
        Mix.shell().error("Found order_product, aborting seeding order_product.")
    end
  end

  defp generate_order_product(count) do
    orders = Inventory.list_orders(preloads: [])
    products = Inventory.list_products()

    for _ <- 1..count do
      %{id: order_id} = Enum.random(orders)
      %{id: product_id} = Enum.random(products)

      %{
        order_id: order_id,
        product_id: product_id,
        size: Enum.random(~w(XS S M L XL XXL)a)
      }
    end
  end

  def insert_orders_products(data) do
    %OrdersProducts{}
    |> OrdersProducts.changeset(data)
    |> Repo.insert!()
  end
end

Atomic.Repo.Seeds.OrdersProducts.run()
