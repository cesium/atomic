defmodule AtomicWeb.AnnouncementLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Empty, Pagination, Tabs}

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    announcements_with_flop = list_announcements(socket, params)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Announcements"))
     |> assign(:current_page, :announcements)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:params, params)
     |> assign(announcements_with_flop)
     |> assign(:empty?, Enum.empty?(announcements_with_flop.announcements))
     |> assign(:has_permissions?, has_permissions?(socket))
     |> then(fn complete_socket ->
       assign(complete_socket, :tabs, build_tabs(complete_socket))
     end)}
  end

  defp list_announcements(socket, params) do
    params = Map.put(params, "page_size", 6)

    case current_tab(socket, params) do
      "All" -> list_all_announcements(socket, params)
      "Following" -> list_following_announcements(socket, params)
    end
  end

  defp list_all_announcements(_socket, params) do
    case Organizations.list_announcements(params, preloads: [:organization]) do
      {:ok, {announcements, meta}} ->
        %{announcements: announcements, meta: meta}

      {:error, flop} ->
        %{announcements: [], meta: flop}
    end
  end

  defp list_following_announcements(socket, params) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    case Organizations.list_organizations_announcements(organizations, params,
           preloads: [:organization]
         ) do
      {:ok, {announcements, meta}} ->
        %{announcements: announcements, meta: meta}

      {:error, flop} ->
        %{announcements: [], meta: flop}
    end
  end

  def build_tabs(socket) when not socket.assigns.is_authenticated? do
    %{"#{gettext("All")}" => "load-all"}
  end

  def build_tabs(_socket) do
    %{
      "#{gettext("All")}" => "load-all",
      "#{gettext("Following")}" => "load-following"
    }
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]

  defp current_tab(_socket, _params), do: "All"

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    has_current_organization?(socket) and
      (Accounts.has_permissions_inside_organization?(
         socket.assigns.current_user.id,
         socket.assigns.current_organization.id
       ) or Accounts.has_master_permissions?(socket.assigns.current_user.id))
  end

  defp has_current_organization?(socket) do
    is_map_key(socket.assigns, :current_organization) and
      not is_nil(socket.assigns.current_organization)
  end
end
