defmodule AtomicWeb.SpeakerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    speaker = Activities.get_speaker!(id)

    if speaker.organization_id == organization_id do
      {:noreply,
        socket
        |> assign(:page_title, page_title(socket.assigns.live_action))
        |> assign(:speaker, speaker)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Speaker"
  defp page_title(:edit), do: "Edit Speaker"
end
