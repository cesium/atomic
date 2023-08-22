defmodule AtomicWeb.NewsLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations
  alias Atomic.Organizations.News

  @impl true
  def mount(%{"organization_id" => organization_id}, _session, socket) do
    socket =
      socket
      |> assign(:organization, Organizations.get_organization!(organization_id))
      |> assign(:all_news, list_news(organization_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("News"),
        route: Routes.news_index_path(socket, :index, params["organization_id"])
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :news)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"organization_id" => organization_id, "id" => id}) do
    news = Organizations.get_news!(id)

    if news.organization_id == organization_id do
      socket
      |> assign(:page_title, "Edit News")
      |> assign(:news, Organizations.get_news!(id))
      |> assign(:organization, Organizations.get_organization!(organization_id))
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New News")
    |> assign(:news, %News{})
  end

  defp apply_action(socket, :index, params) do
    organization = Organizations.get_organization!(params["organization_id"])

    socket
    |> assign(:page_title, "#{organization.name}'s News")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    news = Organizations.get_news!(id)
    {:ok, _} = Organizations.delete_news(news)

    {:noreply,
     socket
     |> assign(:all_news, list_news(news.organization_id))}
  end

  defp list_news(organization_id) do
    Organizations.list_news_by_organization_id(organization_id, [:organization])
  end
end
