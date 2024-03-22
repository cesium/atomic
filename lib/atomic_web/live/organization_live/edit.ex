defmodule AtomicWeb.OrganizationLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_name" => organization_name}, _, socket) do
    organization = Organizations.get_organization_by_name!(organization_name)

    {:noreply,
     socket
     |> assign(:page_title, organization_name)
     |> assign(:organization, organization)
     |> assign(:current_page, :organizations)}
  end
end
