defmodule AtomicWeb.OrganizationLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      },
      %{
        name: gettext("%{name}", name: organization.name),
        route: Routes.organization_show_path(socket, :show, organization_id)
      },
      %{
        name: gettext("Edit"),
        route: Routes.organization_edit_path(socket, :edit, organization_id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, organization.name)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organization, organization)
     |> assign(:current_page, :organizations)}
  end
end
