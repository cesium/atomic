defmodule AtomicWeb.PartnerLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Avatar

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Partners

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_name" => organization_name, "id" => id}, _, socket) do
    organization = Organizations.get_organization_by_name!(organization_name)
    partner = Partners.get_partner!(id)

    {:noreply,
     socket
     |> assign(:page_title, partner.name)
     |> assign(:current_page, :partners)
     |> assign(:organization, organization)
     |> assign(:partner, partner)
     |> assign(:has_permissions?, has_permissions?(socket, organization.id))}
  end

  defp has_permissions?(socket, _organization_id) when not socket.assigns.is_authenticated?,
    do: false

  defp has_permissions?(socket, _organization_id)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end
end
