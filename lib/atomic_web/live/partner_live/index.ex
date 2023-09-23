defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty
  import AtomicWeb.Components.Pagination

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Partners

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug} = params, _url, socket) do
    organization = Organizations.get_organization_by_slug(slug)

    entries = [
      %{
        name: gettext("Partners"),
        route: Routes.partner_index_path(socket, :index, slug)
      }
    ]
    IO.inspect(organization)
    partners_with_flop = list_partners(organization.id)

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Partners")}")
     |> assign(:current_page, :partners)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:params, params)
     |> assign(:organization, organization)
     |> assign(partners_with_flop)
     |> assign(:empty?, Enum.empty?(partners_with_flop.partners))
     |> assign(:has_permissions?, has_permissions?(socket, organization.id))}
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
end
