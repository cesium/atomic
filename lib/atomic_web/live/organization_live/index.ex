defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.Organization

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :organizations, list_organizations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries=
      [
        %{
          name: gettext("Organizations"),
          route: Routes.organization_index_path(socket, :index)
        }
      ]

    {:noreply,
     socket
     |> assign(:current_page, :organizations)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
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
    |> assign(:page_title, "Listing Organizations")
    |> assign(:organization, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Organizations.get_organization!(id)
    {:ok, _} = Organizations.delete_organization(organization)

    {:noreply, assign(socket, :organizations, list_organizations())}
  end

  defp list_organizations do
    Organizations.list_organizations()
  end
end
