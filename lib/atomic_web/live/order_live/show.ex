defmodule AtomicWeb.OrderLive.Show do
  use AtomicWeb, :live_view

  import Atomic.Inventory
  alias Atomic.Repo
  alias Atomic.Inventory
  alias Atomic.Uploaders
  alias Atomic.Accounts

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
  def handle_event("canceled", _payload, socket) do
    order = socket.assigns.order
    Inventory.update_status(order, %{status: :canceled})

    {:noreply,
     socket
     |> put_flash(:success, "Order canceled successfly")
     |> redirect(to: Routes.order_index_path(socket, :index))}
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
