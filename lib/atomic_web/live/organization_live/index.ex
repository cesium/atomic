defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      }
    ]

    organizations = Organizations.list_organizations()

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organizations, organizations)
     |> assign(:empty, Enum.empty?(organizations))
     |> assign(:has_permissions, has_permissions?(socket))
     |> assign(:current_page, :organizations)}
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end
end
