defmodule AtomicWeb.SpeakerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => _organization_id, "id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:current_page, :speakers)
     |> assign(:speaker, Activities.get_speaker!(id))}
  end

  defp page_title(:show), do: "Show Speaker"
  defp page_title(:edit), do: "Edit Speaker"
end
