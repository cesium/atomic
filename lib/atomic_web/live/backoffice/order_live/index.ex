defmodule AtomicWeb.Backoffice.OrderLive.Index do
  use AtomicWeb, :live_view
  import Atomic.Inventory
  alias Atomic.Inventory
  alias Atomic.Inventory.Order
  alias Atomic.Uploaders
  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, Inventory.list_orders(preloads: [:products, :user]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Inventory.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end
end
