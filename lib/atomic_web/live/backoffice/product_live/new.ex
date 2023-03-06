defmodule AtomicWeb.Backoffice.ProductLive.New do
  @moduledoc false
  use AtomicWeb, :live_view
  alias Atomic.Inventory.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "New Product")
     |> assign(:product, %Product{})}
  end
end
