defmodule Atomic.Repo.Seeds.Inventory do
  alias Atomic.Repo
  alias Atomic.Inventory.Product
  alias Atomic.Inventory

  def run do
    seed_products()
  end

  def seed_products() do
    case Repo.all(Product) do
      [] ->
        [
          %{
            name: "Saco",
            description: "É um saco",
            price: 200,
            price_partnership: 100,
            stock: 3,
            max_per_user: 1,
            sizes: %{
              xs_size: 1,
              s_size: 1,
              m_size: 1,
              l_size: 1,
              xl_size: 1,
              xxl_size: 1
            },
            store_id: Inventory.get_store_id_by_name("CeSIUM Store")
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            price_partnership: 100,
            stock: 3,
            max_per_user: 1,
            sizes: %{
              xs_size: 1,
              s_size: 1,
              m_size: 1,
              l_size: 1,
              xl_size: 1,
              xxl_size: 1
            },
            store_id: Inventory.get_store_id_by_name("CeSIUM Store")

          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            price_partnership: 100,
            stock: 3,
            max_per_user: 1,
            sizes: %{
              xs_size: 1,
              s_size: 1,
              m_size: 1,
              l_size: 1,
              xl_size: 1,
              xxl_size: 1
            },
            store_id: Inventory.get_store_id_by_name("CeSIUM Store")
          },
          %{
            name: "Lápis",
            description: "É um lápis",
            price: 200,
            price_partnership: 100,
            stock: 3,
            max_per_user: 1,
            sizes: %{
              xs_size: 1,
              s_size: 1,
              m_size: 1,
              l_size: 1,
              xl_size: 1,
              xxl_size: 1
            },
            store_id: Inventory.get_store_id_by_name("CeSIUM Store")
          }
        ]
        |> Enum.each(&insert_product/1)

      _ ->
        Mix.shell().error("Found products, aborting seeding products.")
    end
  end

  defp insert_product(data) do
    %Product{}
    |> Product.changeset(data)
    |> Repo.insert!()
  end
end

Atomic.Repo.Seeds.Inventory.run()
