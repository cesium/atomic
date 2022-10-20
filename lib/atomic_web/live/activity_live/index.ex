defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activites
  alias Atomic.Activites.Activity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :activies, list_activies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Activites.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activies")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activites.get_activity!(id)
    {:ok, _} = Activites.delete_activity(activity)

    {:noreply, assign(socket, :activies, list_activies())}
  end

  defp list_activies do
    Activites.list_activies()
  end
end
