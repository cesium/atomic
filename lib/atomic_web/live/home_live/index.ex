defmodule AtomicWeb.HomeLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Partnerships
  alias Atomic.Uploaders.Card

  import AtomicWeb.CalendarUtils
  import AtomicWeb.Components.Calendar
  import AtomicWeb.ViewUtils

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    partners =
      Partnerships.list_partnerships_by_organization_id(socket.assigns.current_organization.id)

    activities =
      Activities.list_activities_by_organization_id(socket.assigns.current_organization.id, [])

    mode = params["mode"] || "month"

    entries = [
      %{
        name: gettext("Home"),
        route: Routes.home_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, "Home")
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :home)
     |> assign(:partners, partners)
     |> assign(:activities, activities)
     |> assign(:time_zone, socket.assigns.time_zone)
     |> assign(:params, params)
     |> assign(:mode, mode)
     |> assign(
       list_activities(socket.assigns.time_zone, mode, params, socket.assigns.current_user)
     )}
  end

  defp list_activities(time_zone, mode, params, _user) do
    current = current_from_params(time_zone, params)

    start =
      if mode == "month" do
        Timex.beginning_of_month(current) |> Timex.to_naive_datetime()
      else
        Timex.beginning_of_week(current) |> Timex.to_naive_datetime()
      end

    finish =
      if mode == "month" do
        Timex.end_of_month(current) |> Timex.to_naive_datetime()
      else
        Timex.end_of_week(current) |> Timex.to_naive_datetime()
      end

    %{
      sessions: Activities.list_sessions_from_to(start, finish, preloads: [:activity])
    }
  end
end
