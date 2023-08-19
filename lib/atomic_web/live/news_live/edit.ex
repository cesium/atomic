defmodule AtomicWeb.NewsLive.Edit do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id} = _params, _url, socket) do
    news = Organizations.get_news!(id)

    entries = [
      %{
        name: gettext("News"),
        route: Routes.news_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("Edit New"),
        route: Routes.news_edit_path(socket, :edit, id, organization_id)
      }
    ]

    if organization_id == news.organization_id do
      {:noreply,
       socket
       |> assign(:breadcrumb_entries, entries)
       |> assign(:current_page, :activities)
       |> assign(:page_title, gettext("Edit News"))
       |> assign(:news, news)}
    else
      raise AtomicWeb.MismatchError
    end
  end
end
