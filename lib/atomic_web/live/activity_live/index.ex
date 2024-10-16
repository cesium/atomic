defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Empty, Pagination, Tabs}

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("Activities"))
     |> assign(:current_page, :activities)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:params, params)
     |> assign(:has_permissions?, has_permissions?(socket))
     |> assign(list_activities(socket, params))
     |> then(fn complete_socket ->
       assign(complete_socket, :empty?, Enum.empty?(complete_socket.assigns.activities))
     end)}
  end

  defp list_activities(socket, params) do
    params = Map.put(params, "page_size", 6)

    case current_tab(socket, params) do
      "all" -> list_all_activities(socket, params)
      "following" -> list_following_activities(socket, params)
      "upcoming" -> list_upcoming_activities(socket, params)
      "enrolled" -> list_enrolled_activities(socket, params)
    end
  end

  defp list_all_activities(_socket, params) do
    case Activities.list_activities(params, preloads: [:enrollments]) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_following_activities(socket, params) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    case Activities.list_organizations_activities(organizations, params, preloads: [:enrollments]) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_upcoming_activities(_socket, params) do
    case Activities.list_upcoming_activities(params, preloads: [:enrollments]) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_enrolled_activities(socket, params) do
    case Activities.list_user_activities(socket.assigns.current_user.id, params,
           preloads: [:enrollments]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]
  defp current_tab(_socket, _params), do: "all"

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
