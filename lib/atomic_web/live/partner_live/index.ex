defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Partnerships

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Partners")}",
        route: Routes.partner_index_path(socket, :index, organization_id)
      }
    ]

    partners = Partnerships.list_partnerships_by_organization_id(organization_id)

    {:noreply,
     socket
     |> assign(:current_page, :partners)
     |> assign(:page_title, "#{organization.name}'s #{gettext("Partners")}")
     |> assign(:breadcrumb_entries, entries)
     |> assign(:partners, partners)
     |> assign(:empty?, Enum.empty?(partners))
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
