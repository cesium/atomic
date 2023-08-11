defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    organizations = list_organizations(params)

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:params, params)
     |> assign(:organizations, organizations)
     |> assign(:current_page, :organizations)
     |> assign(:role, maybe_get_role(socket))}
  end

  defp apply_action(socket, :show, %{"organization_id" => id}) do
    socket
    |> assign(:page_title, "Show Organization")
    |> assign(:organization, Organizations.get_organization!(id))
  end

  defp apply_action(socket, :edit, %{"organization_id" => id}) do
    socket
    |> assign(:page_title, "Edit Organization")
    |> assign(:organization, Organizations.get_organization!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organization")
    |> assign(:organization, %Organization{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Organizations")
    |> assign(:organization, nil)
  end

  @impl true
  def handle_event("delete", %{"organization_id" => id}, socket) do
    organization = Organizations.get_organization!(id)
    {:ok, _} = Organizations.delete_organization(organization)

    {:noreply, assign(socket, :organizations, list_organizations(socket.assigns.params))}
  end

  defp list_organizations(params) do
    Organizations.list_organizations(params)
  end

  defp maybe_get_role(socket) do
    case socket.assigns.current_user do
      nil ->
        nil

      _ ->
        socket.assigns.current_user.role
    end
  end
end
