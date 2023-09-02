defmodule AtomicWeb.PartnerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Partnerships

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    partner = Partnerships.get_partner!(id)

    entries = [
      %{
        name: gettext("Partners"),
        route: Routes.partner_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("%{name}", name: partner.name),
        route: Routes.partner_show_path(socket, :show, organization_id, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, partner.name)
     |> assign(:current_page, :partners)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:partner, partner)}
  end
end
