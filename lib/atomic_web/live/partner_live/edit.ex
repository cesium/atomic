defmodule AtomicWeb.PartnerLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Partners

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => partner_id} = _params, _, socket) do
    partner = Partners.get_partner!(partner_id)

    {:noreply,
     socket
     |> assign(:page_title, partner.name)
     |> assign(:partner, partner)
     |> assign(:current_page, :partner)}
  end

  @impl true
  def handle_event("delete", %{"partner_id" => partner_id}, socket) do
    partner = Partners.get_partner!(partner_id)
    case Partners.delete_partner(partner) do
      {:ok, _partner} ->
        {:noreply, push_patch(socket, to: Routes.partner_index_path(socket, organization_id: partner.organization_id))}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete partner")}
    end
  end
end
