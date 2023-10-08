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

    {:noreply,
     socket
     |> assign(:current_page, :activities)
     |> assign(:page_title, gettext("Edit Activity"))
     |> assign(:activity, activity)}
  end
end
