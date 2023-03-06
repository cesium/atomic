defmodule AtomicWeb.ProductLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Inventory
  alias Atomic.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, Inventory.list_products())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :products)
     |> assign(:page_title, "CeSIUM Store - Products")}
  end
end
