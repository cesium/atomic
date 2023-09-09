defmodule AtomicWeb.SpeakerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    entries = [
      %{
        name: gettext("Speakers"),
        route: Routes.speaker_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("Show"),
        route: Routes.speaker_show_path(socket, :show, organization_id, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:current_page, :speakers)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:speaker, Activities.get_speaker!(id))}
  end

  defp page_title(:show), do: "Show Speaker"
  defp page_title(:edit), do: "Edit Speaker"
end
