defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    organization = Organizations.get_organization!(id, [:departments])
    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.speaker_index_path(socket, :index)
      },
      %{
        name: organization.name,
        route: Routes.organization_show_path(socket, :show, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, organization.name)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organization, Organizations.get_organization!(id, [:departments]))}
  end

  defp page_title(:show), do: "Show Organization"
  defp page_title(:edit), do: "Edit Organization"
end
