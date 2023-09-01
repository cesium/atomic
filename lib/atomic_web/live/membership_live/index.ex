defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  import AtomicWeb.Helpers
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    memberships =
      Organizations.list_memberships(%{"organization_id" => organization_id}, [:user, :created_by])
      |> Enum.sort_by(& &1.user.name)

    organization = Organizations.get_organization!(organization_id)

    entries = [
      %{
        name: "#{organization.name}'s #{gettext("Memberships")}",
        route: Routes.membership_index_path(socket, :index, organization_id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Memberships")}")
     |> assign(:current_page, :memberships)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:memberships, memberships)}
  end
end
