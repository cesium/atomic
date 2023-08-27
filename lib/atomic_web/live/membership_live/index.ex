defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  import AtomicWeb.Helpers
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"handle" => handle}, _, socket) do
    organization = Organizations.get_organization_by_handle(handle)

    memberships =
      Organizations.list_memberships(%{"organization_id" => organization.id}, [:user, :created_by])
      |> Enum.sort_by(& &1.user.name)

    entries = [
      %{
        name: gettext("Memberships"),
        route: Routes.membership_index_path(socket, :index, handle)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :memberships)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
     |> assign(:memberships, memberships)}
  end

  defp page_title(:index, organization), do: "#{organization.name}'s Memberships"
  defp page_title(:show, organization), do: "#{organization.name}'s Membership"
  defp page_title(:edit, _), do: "Edit membership"
end
