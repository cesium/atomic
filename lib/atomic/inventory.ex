defmodule Atomic.Inventory do
  @moduledoc """
  The Inventory context.
  """

  use Atomic.Context
  alias Atomic.Repo
  alias Atomic.Accounts.User
  alias Atomic.Inventory.Product
  alias Atomic.Inventory.Order
  alias Atomic.Inventory.OrdersProducts
  alias Atomic.Inventory

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id, opts) when is_list(opts) do
    Product
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs, after_save \\ &{:ok, &1}) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  @doc """
  Updates a product image

  ## Examples
        iex> update_product_image(product, %{field: new_value})
        {:ok, %Product{}}

        iex> update_product_image(product, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

  """
  def update_product_image(%Product{} = product, attrs) do
    product
    |> Product.image_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    product
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:orders,
      name: :orders_product_id_fkey,
      message: "cannot delete product because it has orders"
    )
    |> Repo.delete()
    |> broadcast(:deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Atomic.Inventory.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def update_status(order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns the list of orders_products.
    iex> list_orders_products()
    [%OrdersProducts{}, ...]
  """
  def list_orders_products() do
    OrdersProducts
    |> Repo.all()
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order_product relationship.

  ## Examples

    iex> create_order_product(%{field: value})
    {:ok, %OrdersProducts{}}

    iex> create_order_product(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_order_product(attrs) do
    %OrdersProducts{}
    |> OrdersProducts.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an order_product.

  ## Examples

      iex> update_order_product(order_product, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order_product(order_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_product(%OrdersProducts{} = orders_product, attrs) do
    orders_product
    |> OrdersProducts.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  @doc """
    Returns a function that can be used to broadcast the given event.

    iex> subscribe(topic)
    {:ok, #PID<0.0.0>}

  """
  def subscribe(topic) when topic in ["purchased", "updated", "deleted"] do
    Phoenix.PubSub.subscribe(Atomic.PubSub, topic)
  end

  @doc """
    Function that is used to purchase a product.

  ## Examples
    iex> purchase(user, product)
    {:ok, %Order{}}

    iex> purchase(user, product)
    {:error, %Ecto.Changeset{}}
  """
  alias Atomic.Accounts.User

  def purchase(%User{} = user, %Product{} = product, product_params) do
    order =
      Order
      |> where(user_id: ^user.id)
      |> where(status: :draft)
      |> Repo.one()
      |> Repo.preload([:user, :products])

    if order do
      order_product =
        OrdersProducts
        |> where(order_id: ^order.id)
        |> where(product_id: ^product.id)
        |> Repo.one()

      {val, _} = Integer.parse(product_params["quantity"])

      if order_product != nil do
        if order_product.quantity + val <= product.max_per_user do
          update_order_product(order_product, %{quantity: order_product.quantity + val})
        else
          {:error, "The maximum quantity for this product per user is #{product.max_per_user}"}
        end
      else
        add_product_to_order(order, product, product_params)
      end
    else
      {:ok, order} = create_order(%{user_id: user.id})
      add_product_to_order(order, product, product_params)
    end
  end

  def add_product_to_order(%Order{} = order, %Product{} = product, product_params) do
    {val, _} = Integer.parse(product_params["quantity"])
    size = product_params["size"]

    if update_stock_sizes(product, size, val) == {:error, "Not enough stock"} do
      {:error, "Not enough stock"}
    else
      create_order_product(%{
        order_id: order.id,
        product_id: product.id,
        quantity: val,
        size: size
      })
    end
  end

  def update_stock_sizes(product, size, quantity) do
    new_sizes =
      case size do
        "XS" -> Map.put(product.sizes, :xs_size, product.sizes.xs_size - quantity)
        "S" -> Map.put(product.sizes, :s_size, product.sizes.s_size - quantity)
        "M" -> Map.put(product.sizes, :m_size, product.sizes.m_size - quantity)
        "L" -> Map.put(product.sizes, :l_size, product.sizes.l_size - quantity)
        "XL" -> Map.put(product.sizes, :xl_size, product.sizes.xl_size - quantity)
        "XXL" -> Map.put(product.sizes, :xxl_size, product.sizes.xxl_size - quantity)
      end

    values = Map.values(new_sizes) |> Enum.filter(&is_integer/1)

    if Enum.any?(values, &(&1 < 0)) or product.stock - quantity < 0 do
      {:error, "Not enough stock"}
    else
      product
      |> Product.changeset(%{
        stock: product.stock - quantity,
        sizes: %{
          xs_size: new_sizes.xs_size,
          s_size: new_sizes.s_size,
          m_size: new_sizes.m_size,
          l_size: new_sizes.l_size,
          xl_size: new_sizes.xl_size,
          xxl_size: new_sizes.xxl_size
        }
      })
      |> Repo.update!()

      {:ok, "Product added to cart"}
    end
  end

  @doc """


  """

  def checkout_order(order) do
    order
    |> Order.changeset(%{status: :ordered})
    |> Repo.update()
  end

  @doc """
  Function which verifies that the user has 1 or more of each product in his cart.
  ## Examples
   iex> redeem_quantity(user)
   {:ok, %Order{}}

   iex> redeem_quantity(user)
   {:error, %Ecto.Changeset{}}

  """

  def redeem_quantity(product_id) do
    order_quantity = Enum.count(list_orders(preloads: []))

    quantity =
      case order_quantity do
        0 -> Inventory.get_product!(product_id, []).max_per_user
        _ -> Inventory.get_product!(product_id, []).max_per_user - order_quantity
      end

    if quantity < 0 do
      {:error, "You must buy at least one product"}
    else
      quantity
    end
  end

  def capitalize_status(status) do
    status
    |> Atom.to_string()
    |> String.capitalize()
  end

  def total_price(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price end)
  end

  def total_price_with_partnership(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price_partnership end)
  end

  def discount(order) do
    total_price(order) - total_price_with_partnership(order)
  end

  def total_price_cart(id) do
    order =
      Order
      |> where(user_id: ^id)
      |> where(status: :draft)
      |> Repo.one()

    order =
      order
      |> Repo.preload(:products)

    if order do
      Enum.reduce(order.products, 0, fn product, acc ->
        acc + product.price
      end)
    else
      0
    end
  end

  def total_price_partnership_cart(id) do
    order =
      Order
      |> where(user_id: ^id)
      |> where(status: :draft)
      |> Repo.one()

    order =
      order
      |> Repo.preload(:products)

    if order do
      Enum.reduce(order.products, 0, fn product, acc ->
        acc + product.price_partnership
      end)
    else
      0
    end
  end

  def change_status(order, status) do
    order
    |> Order.changeset(status)
    |> Repo.update()
  end

  def discount_cart(id) do
    total_price_cart(id) - total_price_partnership_cart(id)
  end

  alias Atomic.Inventory.OrderHistory

  def create_orders_history(order) do
    %OrderHistory{}
    |> OrderHistory.changeset(order)
    |> Repo.insert()
  end

  def list_orders_history(opts) when is_list(opts) do
    OrderHistory
    |> apply_filters(opts)
    |> Repo.all()
  end

  def get_order_product_by_ids(order_id, product_id) do
    OrdersProducts
    |> where(order_id: ^order_id)
    |> where(product_id: ^product_id)
    |> Repo.one()
  end

  def get_order_draft_by_id(user_id, opts) when is_list(opts) do
    Order
    |> where(user_id: ^user_id)
    |> where(status: :draft)
    |> Repo.one()
    |> apply_filters(opts)
  end

  def update_size_quantity(product_id, size, quantity) do
    product = Inventory.get_product!(product_id, [])

    new_sizes =
      case size do
        "XS" -> Map.put(product.sizes, :xs_size, product.sizes.xs_size + quantity)
        "S" -> Map.put(product.sizes, :s_size, product.sizes.s_size + quantity)
        "M" -> Map.put(product.sizes, :m_size, product.sizes.m_size + quantity)
        "L" -> Map.put(product.sizes, :l_size, product.sizes.l_size + quantity)
        "XL" -> Map.put(product.sizes, :xl_size, product.sizes.xl_size + quantity)
        "XXL" -> Map.put(product.sizes, :xxl_size, product.sizes.xxl_size + quantity)
      end

    product
    |> Product.changeset(%{
      stock: product.stock + quantity,
      sizes: %{
        xs_size: new_sizes.xs_size,
        s_size: new_sizes.s_size,
        m_size: new_sizes.m_size,
        l_size: new_sizes.l_size,
        xl_size: new_sizes.xl_size,
        xxl_size: new_sizes.xxl_size
      }
    })
    |> Repo.update!()
  end

  def cancel_order(order) do
    order
    |> Order.changeset(%{status: :canceled})
    |> Repo.update()

    order
    |> Repo.preload(:products)

    product = order.product
    order_product = get_order_product_by_ids(order.id, product.id)

    Enum.each(order.products, fn product ->
      Inventory.update_product(product.id, %{stock: product.stock + order_product.quantity})
      Inventory.update_size_quantity(product.id, order_product.size, order_product.quantity)
    end)

    {:ok, order}
  end

  def cancel_order_product(order, product) do
    order
    |> Repo.preload(:products)

    order_product =
      OrdersProducts
      |> where(order_id: ^order.id)
      |> where(product_id: ^product.id)

    Inventory.update_product(product.id, %{stock: product.stock + order_product.quantity})
    Inventory.update_size_quantity(product.id, order_product.size, order_product.quantity)

    order_product
    |> Repo.delete_all()

    {:ok, order}
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:purchased] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "purchased", {event, product.stock})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:updated] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "updated", {event, product})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:deleted] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "deleted", {event, product})
    {:ok, product}
  end
end
