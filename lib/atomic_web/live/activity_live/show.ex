defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Avatar

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.ActivityEnrollment

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe("new_enrollment")
      Activities.subscribe("deleted_enrollment")
    end

    {:ok, socket |> assign(:id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:speakers, :organization])

    {:noreply,
     socket
     |> assign(:page_title, "#{activity.title}")
     |> assign(:current_page, :activities)
     |> assign(:activity, activity)
     |> assign(:enrolled, activity.enrolled)
     |> assign(:enrolled?, maybe_put_enrolled(socket))
     |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(id))
     |> then(fn complete_socket ->
       assign(complete_socket, :has_permissions?, has_permissions?(complete_socket))
     end)}
  end

  @impl true
  def handle_event("enroll", _payload, socket) do
    case Activities.create_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {:ok, %ActivityEnrollment{}} ->
        {:noreply,
         socket
         |> put_flash(:success, "Enrolled successufully!")
         |> assign(:enrolled?, true)}

      {:error, changeset} ->
        case is_nil(changeset.errors[:activity_id]) do
          true -> {:noreply, socket |> put_flash(:error, "Unable to enroll")}
          _ -> {:noreply, socket |> put_flash(:error, changeset.errors[:activity_id] |> elem(0))}
        end
    end
  end

  @impl true
  def handle_event("unenroll", _payload, socket) do
    case Activities.delete_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {1, nil} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Unenrolled successufully!"))
         |> assign(:enrolled?, false)}

      {_, nil} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("Unable to unenroll. Please try again."))}
    end
  end

  @impl true
  def handle_event("must-login", _payload, socket) do
    {:noreply,
     socket
     |> put_flash(:error, gettext("You must be logged in to enroll in an activity."))
     |> push_navigate(to: Routes.user_session_path(socket, :new))}
  end

  @impl true
  def handle_info({event, _changes}, socket)
      when event in [:new_enrollment, :deleted_enrollment] do
    {:noreply, reload(socket, action: event)}
  end

  defp reload(socket, action: :new_enrollment) do
    socket
    |> assign(:enrolled, socket.assigns.enrolled + 1)
    |> assign(:enrolled?, maybe_put_enrolled(socket))
    |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(socket.assigns.id))
  end

  defp reload(socket, action: :deleted_enrollment) do
    socket
    |> assign(:enrolled, socket.assigns.enrolled - 1)
    |> assign(:enrolled?, maybe_put_enrolled(socket))
    |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(socket.assigns.id))
  end

  defp maybe_put_enrolled(socket) when not socket.assigns.is_authenticated?, do: false

  defp maybe_put_enrolled(socket) do
    Activities.participating?(socket.assigns.id, socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.activity.organization_id
      )
  end
end
