defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Departments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:department, Departments.get_department!(id, preloads: :activities))}
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
