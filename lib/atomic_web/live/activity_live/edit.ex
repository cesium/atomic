defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id} = _params, _url, socket) do
    activity = Activities.get_activity!(id, preloads: [:sessions, :departments, :speakers])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("Edit Activity"),
        route: Routes.activity_edit_path(socket, :edit, id, organization_id)
      }
    ]

    organizations = Activities.get_session_organizations!(activity)

    if organization_id in organizations do
      {:noreply,
       socket
       |> assign(:breadcrumb_entries, entries)
       |> assign(:current_page, :activities)
       |> assign(:page_title, gettext("Edit Activity"))
       |> assign(
         :activity,
         Activities.get_activity!(id, [:sessions, :speakers, :departments])
       )}
    else
      raise AtomicWeb.MismatchError
    end
  end
end
