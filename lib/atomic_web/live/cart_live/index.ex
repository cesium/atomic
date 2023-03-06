defmodule AtomicWeb.CartLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view
  import Atomic.Inventory
  alias Atomic.Mailer
  alias AtomicWeb.Emails.OrdersEmail

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
    {:ok, assign(socket, :orders, list_orders(preloads: :products))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :cart)}
  end

  @impl true
  def handle_event("checkout", _payload, socket) do
    current_user = socket.assigns.current_user

    order = get_order_draft_by_id(current_user.id, preloads: [])

    order
    |> update_order(%{status: :ordered})

    OrdersEmail.ordered(order.id, to: current_user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> put_flash(:info, "Order placed successfully")
     |> push_redirect(to: Routes.order_index_path(socket, :index))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user

    order = get_order_draft_by_id(current_user.id, preloads: :products)

    quantity = Enum.count(order.products)

    if quantity == 1 do
      order
      |> cancel_order()
    else
      product = get_product!(id, preloads: [])

      order
      |> cancel_order_product(product)
    end

    {:noreply,
     socket
     |> put_flash(:info, "Product removed successfully")
     |> push_redirect(to: Routes.order_index_path(socket, :index))}
  end

  defp get_quantity(order_id, product_id) do
    order_product = get_order_product_by_ids(order_id, product_id)

    order_product.quantity
  end

  defp get_size(order_id, product_id) do
    order_product = get_order_product_by_ids(order_id, product_id)

    order_product.size
  end
end
