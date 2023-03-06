defmodule AtomicWeb.Backoffice.OrderLive.Show do
  use AtomicWeb, :live_view

  import Atomic.Inventory
  alias Atomic.Repo
  alias Atomic.Inventory
  alias Atomic.Uploaders
  alias Atomic.Accounts
  alias AtomicWeb.Emails.OrdersEmail
  alias Atomic.Mailer
  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, order: Inventory.get_order!(id))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))}
  end

  @impl true
  def handle_event("paid", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.update_status(order, %{status: :paid})

    Inventory.create_orders_history(%{status: :paid, admin_id: admin.id, order_id: order.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.paid(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> put_flash(:info, "Order status updated successfly")
     |> push_redirect(to: socket.assigns.return_to)}
  end

  @impl true
  def handle_event("delivered", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.change_status(order, %{status: :delivered})

    Inventory.create_orders_history(%{status: :delivered, admin_id: admin.id, order_id: order.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.delivered(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> put_flash(:info, "Order status updated successfly")
     |> push_redirect(to: socket.assigns.return_to)}
  end

  def handle_event("ready", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.change_status(order, %{status: :ready, admin_id: admin.id})
    Inventory.create_orders_history(%{status: :ready, admin_id: admin.id, order_id: order.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.ready(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> put_flash(:info, "Order status updated successfly")
     |> push_redirect(to: socket.assigns.return_to)}
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
