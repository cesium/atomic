defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  import AtomicWeb.LiveHelpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:organization])

    {:noreply,
     socket
     |> assign(:page_title, "Edit Activity")
     |> assign_page_metadata(:edit_activity)
     |> assign(:current_page, :activities)
     |> assign(:current_organization, activity.organization)
     |> assign(:activity, activity)}
  end
end
