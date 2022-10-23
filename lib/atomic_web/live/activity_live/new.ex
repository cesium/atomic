defmodule AtomicWeb.ActivityLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities.Activity
  alias Atomic.Activities.Session

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("New Activity"))
     |> assign(:activity, %Activity{
       activity_sessions: [%Session{}]
     })}
  end
end
