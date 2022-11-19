defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:department, :activity_sessions])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, Activites.get_activity!(id))}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"
end
