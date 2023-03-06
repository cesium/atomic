defmodule AtomicWeb.ProductLive.FormComponent do
  @moduledoc false
  use AtomicWeb, :live_component

  import Atomic.Inventory
  alias Atomic.Uploaders

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:id, id)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:product, get_product!(id, preloads: :order))
     |> assign(:current_page, :products)}
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    product = socket.assigns.product
    user = socket.assigns.user

    case purchase(user, product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product added to cart successfully!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, message} ->
        {:noreply,
         socket
         |> put_flash(:error, message)
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp get_available_sizes(product) do
    sizes = [
      {product.sizes.xs_size, "XS"},
      {product.sizes.s_size, "S"},
      {product.sizes.m_size, "M"},
      {product.sizes.l_size, "L"},
      {product.sizes.xl_size, "XL"},
      {product.sizes.xxl_size, "XXL"}
    ]

    list =
      sizes
      |> Enum.filter(fn {count, _} -> count > 0 end)
      |> Enum.map(fn {_, size} -> size end)

    list
  end
end
