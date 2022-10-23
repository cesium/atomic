defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, Activities.get_activity!(id, [:activity_sessions]))}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Activities.delete_activity(socket.assigns.activity)

    {:noreply, push_redirect(socket, to: Routes.activity_index_path(socket, :index))}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"
end