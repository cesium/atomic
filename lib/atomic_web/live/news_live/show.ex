defmodule AtomicWeb.NewsLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    news = Organizations.get_news!(id)

    entries = [
      %{
        name: gettext("News"),
        route: Routes.news_index_path(socket, :index)
      },
      %{
        name: gettext("%{title}", title: news.title),
        route: Routes.news_show_path(socket, :show, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, "Show #{news.title}")
     |> assign(:current_page, :departments)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:news, news)
     |> assign(:has_permissions, has_permissions?(socket))}
  end

  defp has_permissions?(socket)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
