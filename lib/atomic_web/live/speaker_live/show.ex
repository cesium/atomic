defmodule AtomicWeb.SpeakerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    speaker = Activities.get_speaker!(id)

    entries = [
      %{
        name: gettext("Speakers"),
        route: Routes.speaker_index_path(socket, :index)
      },
      %{
        name: speaker.name,
        route: Routes.speaker_show_path(socket, :show, id)
      }
    ]

    activities_sessions = Activities.get_activity_by_speaker!(id) |> IO.inspect()

    activities =
      activities_sessions
      |> Enum.map(fn activity -> Activities.get_activity!(activity.activity_id) end)

    {:noreply,
     socket
     |> assign(:current_page, :speakers)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     # |> assign(:activities, activities)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:speaker, speaker)}
  end

  defp page_title(:show), do: "Show Speaker"
  defp page_title(:edit), do: "Edit Speaker"
end
