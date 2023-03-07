defmodule AtomicWeb.ActivityLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("Edit Activity"))
     |> assign(
       :activity,
       Activities.get_activity!(id, [:activity_sessions, :speakers, :departments])
     )}
  end
end
