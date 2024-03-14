defmodule AtomicWeb.DepartmentLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations.Department

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :department)
     |> assign(:page_title, gettext("New Department"))
     |> assign(:department, %Department{organization_id: organization_id})}
  end
end
