defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Avatar, Button, Empty, Pagination, Tabs}
  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Partners

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = params, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    partners_with_flop = list_partners(organization_id)

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Partners")}")
     |> assign(:current_page, :partners)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:params, params)
     |> assign(:organization, organization)
     |> assign(partners_with_flop)
     |> assign(:empty?, Enum.empty?(partners_with_flop.partners))
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end

  defp list_partners(id, params \\ %{}) do
    case Partners.list_partners(params, where: [organization_id: id]) do
      {:ok, {partners, meta}} ->
        %{partners: partners, meta: meta}

      {:error, flop} ->
        %{partners: [], meta: flop}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]
  defp current_tab(_socket, _params), do: "all"
end
