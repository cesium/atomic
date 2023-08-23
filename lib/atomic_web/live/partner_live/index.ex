defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.Partner
  alias Atomic.Partnerships

  import AtomicWeb.Components.Pagination

  @impl true
  def mount(%{"organization_id" => organization_id} = params, _session, socket) do
    {:ok, assign(socket, list_partnerships(organization_id, params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Partners"),
        route: Routes.partner_index_path(socket, :index, params["organization_id"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :partners)
     |> assign(list_partnerships(params["organization_id"], params))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:params, params)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"organization_id" => organization_id, "id" => id}) do
    partner = Partnerships.get_partner!(id)

    if partner.organization_id == organization_id do
      socket
      |> assign(:page_title, "Edit Partner")
      |> assign(:partner, Partnerships.get_partner!(id))
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Partner")
    |> assign(:partner, %Partner{})
  end

  defp apply_action(socket, :index, params) do
    organization = Organizations.get_organization!(params["organization_id"])

    socket
    |> assign(:page_title, "#{organization.name}'s Partners")
    |> assign(:partner, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    partner = Partnerships.get_partner!(id)
    {:ok, _} = Partnerships.delete_partner(partner)

    {:noreply,
     assign(socket, :partnerships, list_partnerships(socket.assigns.current_organization.id, socket.params))}
  end

  defp list_partnerships(id, params) do
    case Partnerships.list_partnerships(params, where: [organization_id: id]) do
      {:ok, {partnerships, meta}} ->
        %{partnerships: partnerships, meta: meta}
      {:error, flop} ->
        %{partnerships: [], meta: flop}
    end
  end
end
