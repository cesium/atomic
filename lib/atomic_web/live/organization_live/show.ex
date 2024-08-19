defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.{Accounts, Organizations}

  import AtomicWeb.OrganizationLive.Components.OrganizationAbout
  import AtomicWeb.Components.{Gradient, Tabs}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    organization = Organizations.get_organization!(id)

    {:noreply,
     socket
     |> assign(:page_title, organization.name)
     |> assign(:current_page, :organization)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:organization, organization)
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]
  defp current_tab(_socket, _params), do: "about"

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    has_current_organization?(socket) and
      (Accounts.has_permissions_inside_organization?(
         socket.assigns.current_user.id,
         socket.assigns.current_organization.id
       ) or Accounts.has_master_permissions?(socket.assigns.current_user.id))
  end

  defp has_current_organization?(socket) do
    is_map_key(socket.assigns, :current_organization) and
      not is_nil(socket.assigns.current_organization)
  end
end
