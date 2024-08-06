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

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Partners")}")
     |> assign(:current_page, :partners)
     |> assign(:params, params)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:organization, organization)
     |> assign(list_partners(socket, organization_id, params))
     |> then(fn complete_socket ->
       assign(complete_socket, :empty?, Enum.empty?(complete_socket.assigns.partners))
     end)
     |> assign(:has_permissions?, has_permissions?(socket, organization_id))}
  end

  defp has_permissions?(socket, organization_id) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        organization_id
      )
  end

  defp list_partners(socket, id, params) do
    case current_tab(socket, params) do
      "all" -> list_all_partners(id, params)
      "inactive" -> list_archived_partners(id, params)
    end
  end

  def list_all_partners(id, params \\ %{}) do
    case Partners.list_partners(params, where: [organization_id: id, archived: false]) do
      {:ok, {partners, meta}} ->
        %{partners: partners, meta: meta}

      {:error, flop} ->
        %{partners: [], meta: flop}
    end
  end

  def list_archived_partners(id, params \\ %{}) do
    case Partners.list_partners(params, where: [organization_id: id, archived: true]) do
      {:ok, {partners, meta}} ->
        %{partners: partners, meta: meta}

      {:error, flop} ->
        %{partners: [], meta: flop}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab") do
    params["tab"]
  end

  defp current_tab(_socket, _params), do: "all"
end
