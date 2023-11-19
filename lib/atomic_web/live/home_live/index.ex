defmodule AtomicWeb.HomeLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Feed
  alias Atomic.Organizations
  alias AtomicWeb.Components.Activity
  alias AtomicWeb.Components.Announcement

  @impl true
  def mount(_params, _session, socket) do
    limit = 20
    offset = 0

    {:ok,
     socket
     |> stream(:posts, list_posts(limit, offset))
     |> assign(:limit, limit)
     |> assign(:offset, offset)}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:page_title, gettext("Home"))
     |> assign(:schedule, fetch_schedule(socket))
     |> assign(:organizations, list_organizations_to_follow(socket))}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {:noreply,
     socket
     |> update(:offset, fn offset -> offset + socket.assigns.limit end)
     |> stream(:posts, list_posts(socket.assigns.limit, socket.assigns.offset))}
  end

  defp list_posts(limit, offset) do
    Feed.list_posts(
      order_by: [desc: :publish_at],
      limit: limit,
      offset: offset
    )
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
end
