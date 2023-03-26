defmodule AtomicWeb.MembershipLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization" => organization_id, "id" => id}, _, socket) do
    organization = Organizations.get_organization!(organization_id, [:departments])

    membership = Organizations.get_membership!(id, [:user, :organization, :created_by])

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      },
      %{
        name: organization.name,
        route: Routes.organization_show_path(socket, :show, organization_id)
      },
      %{
        name: "Memberships",
        route: Routes.membership_index_path(socket, :index, organization_id)
      },
      %{
        # name: membership.user.name,
        name: "John Doe",
        route: Routes.membership_show_path(socket, :show, organization_id, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, organization.name)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:membership, membership)}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
