defmodule AtomicWeb.ProductLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :products)
     |> assign(:page_title, "Edit Product")
     |> assign(:product, Inventory.get_product!(id, []))
     |> assign(:current_user, socket.assigns.current_user)}
  end
end
