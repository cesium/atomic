defmodule AtomicWeb.DepartmentLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Departments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    department = Departments.get_department!(id, preloads: [:activities])
    if department.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:department, department)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Department"
  defp page_title(:edit), do: "Edit Department"
end
