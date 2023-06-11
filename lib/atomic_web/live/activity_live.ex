defmodule AtomicWeb.ActivityLive do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <h1>Listing Activities</h1>

      <table>
        <thead>
          <tr>
            <th>Title</th>
            <th>Date</th>
            <th>Location</th>
            <th>Minimum entries</th>
            <th>Maximum entries</th>

            <th></th>
          </tr>
        </thead>
        <tbody id="activities">
          <%= for activity <- @activities do %>
            <tr id={"activity-#{activity.id}"}>
              <td><%= activity.title %></td>
              <td><%= hd(activity.activity_sessions).start %></td>
              <td><%= hd(activity.activity_sessions).location.name %></td>
              <td><%= activity.minimum_entries %></td>
              <td><%= activity.maximum_entries %></td>

              <td>
                <span><%= live_redirect("Show", to: Routes.activity_show_path(@socket, :show, activity)) %></span>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
      <span><%= live_patch("New Activity", to: Routes.activity_new_path(@socket, :new)) %></span>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, activities: Activities.list_activities(preloads: [:activity_sessions]))}
  end
end
