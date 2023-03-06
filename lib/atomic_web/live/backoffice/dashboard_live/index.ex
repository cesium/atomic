defmodule AtomicWeb.Backoffice.DashboardLive.Index do
  use AtomicWeb, :live_view
  import Atomic.Inventory
  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :orders, list_orders_history(preloads: [:order, :admin]) |> Enum.reverse())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :dashboard)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  defp user_email(id) do
    if id == nil do
      nil
    else
      Accounts.get_user!(id).email
    end
  end
end
