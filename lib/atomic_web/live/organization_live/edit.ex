defmodule AtomicWeb.OrganizationLive.Edit do
  use AtomicWeb, :live_view

  import AtomicWeb.LiveHelpers

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    organization = Organizations.get_organization!(organization_id)

    {:noreply,
     socket
     |> assign_page_metadata(:organization, organization: organization)
     |> assign(:organization, organization)
     |> assign(:current_page, :organizations)}
  end
end
