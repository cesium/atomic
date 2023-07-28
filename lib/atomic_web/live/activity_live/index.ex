defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Activities.Activity

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :activities, list_activities(params["organization_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Activities.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, assign(socket, :activies, list_activities(socket.assigns.current_organization.id))}
  end

  defp list_activities(organization_id) do
    Activities.list_activities_by_organization_id(organization_id, preloads: [:activity_sessions])
  end
end
