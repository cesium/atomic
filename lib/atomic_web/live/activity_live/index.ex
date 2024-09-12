defmodule AtomicWeb.ActivityLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Empty, Pagination, Tabs}
  import AtomicWeb.ActivityLive.Components.ActivityCard

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
     |> assign(:has_current_organization?, has_current_organization?(socket))
     |> assign(:upcoming_enrolled_count, user_activities_count(socket))
     |> assign(list_activities(socket, params))
     |> then(fn complete_socket ->
       assign(complete_socket, :empty?, Enum.empty?(complete_socket.assigns.activities))
     end)}
  end

  defp list_activities(socket, params) do
    params = Map.put(params, "page_size", 6)

    case current_tab(socket, params) do
      "organization" -> list_organization_activities(socket, params)
      "discover" -> list_discover_activities(socket, params)
      "following" -> list_following_activities(socket, params)
      "enrolled" -> list_enrolled_activities(socket, params)
      "past" -> list_past_activities(socket, params)
    end
  end

  defp list_organization_activities(socket, params) do
    case Activities.list_organization_activities(socket.assigns.current_organization.id, params,
           preloads: [:enrollments, :organization]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_discover_activities(_socket, params) do
    case Activities.list_upcoming_activities(params,
           preloads: [:enrollments, :organization]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_following_activities(socket, params) do
    organizations =
      Organizations.list_organizations_followed_by_user(socket.assigns.current_user.id)

    case Activities.list_organizations_activities(organizations, params,
           preloads: [:enrollments, :organization]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_enrolled_activities(socket, params) do
    case Activities.list_upcoming_user_activities(socket.assigns.current_user.id, params,
           preloads: [:enrollments, :organization]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp list_past_activities(socket, params) do
    case Activities.list_past_user_activities(socket.assigns.current_user.id, params,
           preloads: [:enrollments, :organization]
         ) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]

  defp current_tab(socket, _params) do
    if has_current_organization?(socket), do: "organization", else: "discover"
  end

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

  defp user_activities_count(socket) do
    if socket.assigns.is_authenticated? do
      Activities.user_upcoming_activities_count(socket.assigns.current_user.id)
    else
      0
    end
  end

  defp activities_empty_state_description(tab) do
    case tab do
      "following" -> gettext("The organizations you follow haven't created any activities yet.")
      "upcoming" -> gettext("There are no upcoming activities registered.")
      "enrolled" -> gettext("When you enroll in new activities they will show up here!")
      "past" -> gettext("You haven't participated in any activities yet.")
      _ -> ""
    end
  end
end
