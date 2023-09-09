defmodule AtomicWeb.HomeLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    entries = [
      %{
        name: gettext("Home"),
        route: Routes.home_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, gettext("Home"))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :home)}
  end
end
