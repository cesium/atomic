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
    activity = Activities.get_activity!(id, [:activity_sessions, :speakers, :departments])

    organizations =
      Enum.map(activity.departments, fn department ->
        department.organization_id
      end)

    if organization_id in organizations do
      {:noreply,
       socket
       |> assign(:page_title, gettext("Edit Activity"))
       |> assign(:activity, activity)}
    else
      raise AtomicWeb.MismatchError
    end
  end
end
