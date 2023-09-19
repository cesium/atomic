defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:speakers])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      },
      %{
        name: activity.title,
        route: Routes.activity_show_path(socket, :show, activity)
      },
      %{
        name: gettext("Edit"),
        route: Routes.activity_edit_path(socket, :edit, activity.organization_id, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :activities)
     |> assign(:page_title, gettext("Edit Activity"))
     |> assign(:activity, activity)}
  end
end
