defmodule AtomicWeb.SpeakerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug, "id" => id}, _, socket) do
    speaker = Activities.get_speaker!(id)
    organization = Organizations.get_organization_by_slug(slug)

    entries = [
      %{
        name: gettext("Speakers"),
        route: Routes.speaker_index_path(socket, :index, slug)
      },
      %{
        name: gettext("Show"),
        route: Routes.speaker_show_path(socket, :show, slug, id)
      }
    ]

    if speaker.organization_id == organization.id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:current_page, :speakers)
       |> assign(:breadcrumb_entries, entries)
       |> assign(:speaker, Activities.get_speaker!(id))}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show), do: "Show Speaker"
  defp page_title(:edit), do: "Edit Speaker"
end
