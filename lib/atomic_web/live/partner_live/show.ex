defmodule AtomicWeb.PartnerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Partnerships
  alias Atomic.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    partner = Partnerships.get_partner!(id)

    if partner.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:partner, partner)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Partner"
  defp page_title(:edit), do: "Edit Partner"
end
