defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.Partner

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :organizations, list_organizations())}
  end

  @impl true
  def handle_params(%{"organization" => id}, _url, socket) do
    organization = Organizations.get_organization!(id, [:departments])

   partners =
      Organizations.list_partners([where: [organization_id: id]])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :organizations)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organization, organization)
     |> assign(:partners, partners)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Partner")
    |> assign(:partner, Organizations.get_partner!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Partner")
    |> assign(:partner, %Partner{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Organizations")
    |> assign(:partner, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    partner = Organizations.get_partner!(id)
    {:ok, _} = Organizations.delete_partner(partner)

    {:noreply, assign(socket, :organizations, list_organizations())}
  end

  defp list_organizations do
    Organizations.list_organizations()
  end
end
