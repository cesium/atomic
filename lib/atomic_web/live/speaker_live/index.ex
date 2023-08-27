defmodule AtomicWeb.SpeakerLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Activities.Speaker
  alias Atomic.Organizations

  @impl true
  def mount(%{"handle" => handle}, _session, socket) do
    organization = Organizations.get_organization_by_handle(handle)
    {:ok, assign(socket, :speakers, list_speakers(organization.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Speakers"),
        route: Routes.speaker_index_path(socket, :index, params["handle"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :speakers)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"handle" => handle, "id" => id}) do
    speaker = Activities.get_speaker!(id)
    organization = Organizations.get_organization_by_handle(handle)

    if speaker.organization_id == organization.id do
      socket
      |> assign(:page_title, "Edit Speaker")
      |> assign(:speaker, speaker)
    else
      raise AtomicWeb.MismatchError
    end
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

    {:noreply, assign(socket, :speakers, list_speakers(socket.assigns.current_organization.id))}
  end

  defp list_speakers(organization_id) do
    Activities.list_speakers_by_organization_id(organization_id)
  end
end
