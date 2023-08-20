defmodule AtomicWeb.NewsLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    new = Organizations.get_news!(id)

    entries = [
      %{
        name: gettext("News"),
        route: Routes.news_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("%{title}", title: new.title),
        route: Routes.news_show_path(socket, :show, organization_id, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action, new.title))
     |> assign(:new, new)}
  end

  defp page_title(:show, new), do: "Show #{new}"
  defp page_title(:edit, new), do: "Edit #{new}"
end
