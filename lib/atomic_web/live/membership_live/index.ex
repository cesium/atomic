defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization" => id}, _, socket) do
    organization = Organizations.get_organization!(id, [:departments])

    memberships =
      Organizations.list_members([where: [organization_id: id], preloads: [:user]])

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      },
      %{
        name: organization.name,
        route: Routes.organization_show_path(socket, :show, id)
      },
      %{
        name: "Memberships",
        route: Routes.membership_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, organization.name)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:memberships, memberships)}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
