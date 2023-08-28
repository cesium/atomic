defmodule AtomicWeb.NewsLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Announcement
  import AtomicWeb.Components.Empty

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    entries = [
      %{
        name: gettext("News"),
        route: Routes.news_index_path(socket, :index)
      }
    ]

    all_news = Organizations.list_news(preloads: [:organization])

    {:noreply,
     socket
     |> assign(:page_title, gettext("News"))
     |> assign(:current_page, :news)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:all_news, all_news)
     |> assign(:empty, Enum.empty?(all_news))
     |> assign(:has_permissions, has_permissions?(socket))}
  end

  @impl true
  def handle_event("all", _payload, socket) do
    all_news = Organizations.list_news(preloads: [:organization])
    {:noreply, assign(socket, :all_news, all_news)}
  end

  @impl true
  def handle_event("following", _payload, socket) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    all_news =
      Enum.map(organizations, fn organization ->
        Organizations.list_news_by_organization_id(organization.id, preloads: [:organization])
      end)

    {:noreply, assign(socket, :all_news, List.flatten(all_news))}
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
