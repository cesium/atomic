defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Organizations.Partner
  alias Atomic.Partnerships

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    organization = Organizations.get_organization_by_slug(slug)
    {:ok, assign(socket, :partnerships, list_partnerships(organization.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Partners"),
        route: Routes.partner_index_path(socket, :index, params["handle"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :partners)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:empty, Enum.empty?(socket.assigns.partnerships))
     |> assign(:has_permissions, has_permissions?(socket))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    partner = Partnerships.get_partner!(id)
    {:ok, _} = Partnerships.delete_partner(partner)

    {:noreply,
     assign(socket, :partnerships, list_partnerships(socket.assigns.current_organization.id))}
  end

  defp apply_action(socket, :edit, %{"slug" => slug, "id" => id}) do
    partner = Partnerships.get_partner!(id)
    organization = Organizations.get_organization_by_slug(slug)

    if partner.organization_id == organization.id do
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
    organization = Organizations.get_organization_by_slug(params["slug"])

    socket
    |> assign(:page_title, "#{organization.name}'s Partners")
    |> assign(:partner, nil)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end

  defp list_partnerships(id) do
    Partnerships.list_partnerships_by_organization_id(id)
  end
end
