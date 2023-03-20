defmodule AtomicWeb.SpeakerLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Activities.Speaker
  alias Icons.Heroicons

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :speakers, list_speakers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Speakers"),
        route: Routes.speaker_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :instructors)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Speaker")
    |> assign(:speaker, Activities.get_speaker!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Speaker")
    |> assign(:speaker, %Speaker{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Speakers")
    |> assign(:speaker, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    speaker = Activities.get_speaker!(id)
    {:ok, _} = Activities.delete_speaker(speaker)

    {:noreply, assign(socket, :speakers, list_speakers())}
  end

  defp list_speakers do
    Activities.list_speakers()
  end
end
