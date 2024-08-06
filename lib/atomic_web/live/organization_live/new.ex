defmodule AtomicWeb.OrganizationLive.New do
  use AtomicWeb, :live_view

  alias Atomic.Organizations.Organization

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "New Organization")
     |> assign(:organization, %Organization{})
     |> assign(:current_page, :organization)}
  end
end
