defmodule AtomicWeb.HomeLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Activity, Announcement, Tabs}
  import AtomicWeb.HomeLive.Components.{Schedule, FollowSuggestions}

  alias Atomic.Activities
  alias Atomic.Feed
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    %{entries: entries, metadata: metadata} =
      Feed.list_posts_paginated(order_by: [desc: :inserted_at, desc: :id])

    {:ok,
     socket
     |> stream(:posts, entries)
     |> assign(:metadata, metadata)}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:page_title, gettext("Home"))
     |> assign(:schedule, fetch_schedule(socket))
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:organizations, list_organizations_to_follow(socket))
     |> then(fn complete_socket ->
       assign(complete_socket, :tabs, build_tabs(complete_socket))
     end)}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    cursor_after = socket.assigns.metadata.after

    %{entries: entries, metadata: metadata} =
      case socket.assigns.current_tab do
        "All" ->
          Feed.list_next_posts_paginated(cursor_after, order_by: [desc: :inserted_at, desc: :id])

        "Following" ->
          Feed.list_next_posts_following_paginated([], cursor_after,
            order_by: [desc: :inserted_at, desc: :id]
          )
      end

    {:noreply,
     socket
     |> stream(:posts, entries)
     |> assign(:metadata, metadata)}
  end

  @impl true
  def handle_event("load-all", _, socket) when socket.assigns.current_tab == "All",
    do: {:noreply, socket}

  def handle_event("load-all", _, socket) do
    %{entries: entries, metadata: metadata} =
      Feed.list_posts_paginated(order_by: [desc: :inserted_at, desc: :id])

    {:noreply,
     socket
     |> stream(:posts, entries, reset: true)
     |> assign(:metadata, metadata)
     |> assign(:current_tab, "All")}
  end

  @impl true
  def handle_event("load-following", _, socket) when socket.assigns.current_tab == "Following",
    do: {:noreply, socket}

  def handle_event("load-following", _, socket) do
    current_user = socket.assigns.current_user

    %{entries: entries, metadata: metadata} =
      Organizations.list_memberships(%{"user_id" => current_user.id})
      |> Enum.map(& &1.organization_id)
      |> Feed.list_posts_following_paginated([])

    {:noreply,
     socket
     |> stream(:posts, entries, reset: true)
     |> assign(:metadata, metadata)
     |> assign(:current_tab, "Following")}
  end

  @impl true
  def handle_event("load-schedule", _, socket) do
    {:noreply,
     socket
     |> assign(:current_tab, "Schedule")}
  end

  defp fetch_schedule(socket) when socket.assigns.is_authenticated? do
    {daily, weekly} =
      Activities.list_user_activities(socket.assigns.current_user.id,
        preloads: [:organization],
        order_by: [desc: :start]
      )
      |> Enum.reduce({[], []}, &process_activity/2)

    %{daily: Enum.take(daily, 3), weekly: Enum.take(weekly, 3)}
  end

  defp fetch_schedule(_socket) do
    {daily, weekly} =
      Activities.list_activities(preloads: [:organization], order_by: [desc: :start])
      |> Enum.reduce({[], []}, &process_activity/2)

    %{daily: Enum.take(daily, 3), weekly: Enum.take(weekly, 3)}
  end

  defp process_activity(activity, {daily_acc, weekly_acc}) do
    case within_today_or_this_week(activity.start) do
      :today ->
        {[activity | daily_acc], weekly_acc}

      :this_week ->
        {daily_acc, [activity | weekly_acc]}

      :other ->
        {daily_acc, weekly_acc}
    end
  end

  def build_tabs(socket) when not socket.assigns.is_authenticated? do
    %{"#{gettext("All")}" => "load-all"}
  end

  def build_tabs(socket) do
    options = %{
      "#{gettext("All")}" => "load-all",
      "#{gettext("Following")}" => "load-following"
    }

    if length(socket.assigns.schedule.weekly) + length(socket.assigns.schedule.daily) > 0 do
      Map.put(options, "#{gettext("Schedule")}", "load-schedule")
    else
      options
    end
  end

  defp list_organizations_to_follow(assigns) when assigns.is_authenticated? do
    Organizations.list_top_organizations_for_user(assigns.current_user, limit: 3)
  end

  defp list_organizations_to_follow(_assigns) do
    Organizations.list_top_organizations(limit: 3)
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab"), do: params["tab"]

  defp current_tab(_socket, _params), do: "All"
end
