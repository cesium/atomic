defmodule AtomicWeb.HomeLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Organizations
  alias AtomicWeb.Components.Activity
  alias AtomicWeb.Components.Announcement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:page_title, gettext("Home"))
     |> assign(:posts, list_posts())
     |> assign(:schedule, fetch_schedule(socket))
     |> assign(:organizations, list_organizations_to_follow(socket))}
  end

  defp list_posts do
    activities =
      Activities.list_activities(preloads: [:organization])
      |> Enum.map(fn activity ->
        %{activity | enrolled: Activities.get_total_enrolled(activity.id)}
      end)

    announcements = Organizations.list_announcements(preloads: [:organization])

    Enum.concat(activities, announcements)
    |> Enum.sort(&sort_posts/2)
    |> Enum.map(fn post ->
      case post do
        %Activities.Activity{} ->
          %{type: :activity, activity: post}

        %Organizations.Announcement{} ->
          %{type: :announcement, announcement: post}
      end
    end)
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

  defp list_organizations_to_follow(assigns) when assigns.is_authenticated? do
    Organizations.list_top_organizations_by_user(assigns.current_user, limit: 3)
  end

  defp list_organizations_to_follow(_assigns) do
    Organizations.list_top_organizations(limit: 3)
  end

  # Sort posts by inserted_at, descending. Meaning the newest posts will be on top.
  defp sort_posts(post1, post2) do
    if NaiveDateTime.compare(post1.inserted_at, post2.inserted_at) == :lt do
      false
    else
      true
    end
  end
end
