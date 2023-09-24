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
    entries = [
      %{
        name: gettext("Home"),
        route: Routes.home_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:page_title, gettext("Home"))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:posts, list_posts())
     |> assign(:schedule, fetch_schedule(socket))}
  end

  defp list_posts do
    activities =
      Activities.list_activities(preloads: [:organization])
      |> Enum.map(fn activity ->
        %{activity | enrolled: Activities.get_total_enrolled(activity.id)}
      end)

    announcements = Organizations.list_announcements(preloads: [:organization])

    (activities ++ announcements)
    |> Enum.map(fn post ->
      case post do
        %Activities.Activity{} ->
          %{type: :activity, activity: post}

        %Organizations.Announcement{} ->
          %{type: :announcement, announcement: post}
      end
    end)
  end

  defp fetch_schedule(socket) do
    {daily, weekly} =
      Activities.list_user_activities(socket.assigns.current_user.id, preloads: [:organization])
      |> Enum.reduce({[], []}, fn activity, {daily_acc, weekly_acc} ->
        case within_today_or_this_week(activity.start) do
          :today ->
            {[activity | daily_acc], weekly_acc}

          :this_week ->
            {daily_acc, [activity | weekly_acc]}

          :other ->
            {daily_acc, weekly_acc}
        end
      end)

    %{daily: daily, weekly: weekly}
  end
end
