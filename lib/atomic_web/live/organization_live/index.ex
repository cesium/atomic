defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty
  import AtomicWeb.Components.Pagination

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    organizations_with_flop = list_organizations(params)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Organizations"))
     |> assign(:current_page, :organizations)
     |> assign(:params, params)
     |> assign(organizations_with_flop)
     |> assign(:empty?, Enum.empty?(organizations_with_flop.organizations))
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  defp list_organizations(params) do
    case Organizations.list_organizations(Map.put(params, "page_size", 18)) do
      {:ok, {organizations, meta}} ->
        %{organizations: organizations, meta: meta}

      {:error, flop} ->
        %{organizations: [], meta: flop}
    end
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end
end
