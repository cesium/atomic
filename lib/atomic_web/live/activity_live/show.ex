defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  require Logger

  alias Atomic.Activities

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe("new_enrollment")
      Activities.subscribe("deleted_enrollment")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:department, :activity_sessions])

    {:noreply,
     socket
     |> assign(:enrolled?, Activities.is_user_enrolled?(activity, socket.assigns.current_user))
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity, %{activity | enrolled: Activities.get_total_enrolled(activity)})}
  end

  @impl true
  def handle_event("enroll", _payload, socket) do
    activity = socket.assigns.activity
    current_user = socket.assigns.current_user

    case Activities.create_enrollment(activity, current_user) do
      {:ok, _enrollment} ->
        {:noreply,
         socket
         |> put_flash(:success, "Enrolled successufully!")
         |> set_enrolled(activity, current_user)}

      {:error, error} ->
        Logger.error(error)

        {:noreply,
         socket
         |> put_flash(:error, "Unable to enroll")
         |> set_enrolled(activity, current_user)}
    end
  end

  @impl true
  def handle_event("unenroll", _payload, socket) do
    activity = socket.assigns.activity
    current_user = socket.assigns.current_user

    case Activities.delete_enrollment(activity, current_user) do
      {1, nil} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Unenrolled successufully!"))
         |> set_enrolled(activity, current_user)}

      {_, nil} ->
        {:noreply,
         socket
         |> set_enrolled(activity, current_user)}
    end
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Activities.delete_activity(socket.assigns.activity)

    {:noreply, push_redirect(socket, to: Routes.activity_index_path(socket, :index))}
  end

  @impl true
  def handle_info({event, enrollment}, socket) when event in [:new_enrollment] do
    activity = socket.assigns.activity

    if activity.id == enrollment.activity_id do
      {:noreply,
       assign(socket, :activity, %{activity | enrolled: Activities.get_total_enrolled(activity)})}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({event, _application}, socket) when event in [:deleted_application] do
    activity = socket.assigns.activity

    {:noreply,
     assign(socket, :activity, %{activity | enrolled: Activities.get_total_enrolled(activity)})}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"

  defp set_enrolled(socket, activity, current_user) do
    socket
    |> assign(:enrolled?, Activities.is_user_enrolled?(activity, current_user))
  end
end
