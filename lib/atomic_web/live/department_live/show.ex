defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Departments
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => org, "id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:organization, Organizations.get_organization!(org))
     |> assign(:department, Departments.get_department!(id, preloads: :activities))}
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
