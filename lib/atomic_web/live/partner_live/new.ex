defmodule AtomicWeb.PartnerLive.New do
  use AtomicWeb, :live_view

  alias Atomic.Organizations.Partner

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "New Partner")
     |> assign(:partner, %Partner{})
     |> assign(:current_page, :partner)}
  end
end
