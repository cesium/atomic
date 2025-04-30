defmodule AtomicWeb.OrganizationLive.New do
  use AtomicWeb, :live_view

  import AtomicWeb.LiveHelpers

  alias Atomic.Organizations.Organization

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("New Organization"))
     |> assign_page_metadata(:new_organization)
     |> assign(:organization, %Organization{})
     |> assign(:current_page, :organization)}
  end
end
