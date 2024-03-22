defmodule AtomicWeb.PartnerLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Partners

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => partner_id} = _params, _, socket) do
    partner = Partners.get_partner!(partner_id, preload: [:organization])

    {:noreply,
     socket
     |> assign(:page_title, partner.name)
     |> assign(:partner, partner)
     |> assign(:current_page, :partner)}
  end
end
