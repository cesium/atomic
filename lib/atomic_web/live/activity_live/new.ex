defmodule AtomicWeb.ActivityLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities.Activity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, activity: %Activity{})}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("New Activity"))
     |> assign(
       :page_description,
       gettext(
         "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration"
       )
     )
     |> assign(:current_page, :activities)
     |> assign(:organization_id, organization_id)}
  end
end
