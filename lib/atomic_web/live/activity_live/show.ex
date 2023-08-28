defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Enrollment

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Activities.subscribe("new_enrollment")
      Activities.subscribe("deleted_enrollment")
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    session = Activities.get_session!(id, [:activity, :speakers, :departments])
    activity = Activities.get_activity!(session.activity_id, [:sessions])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      },
      %{
        name: activity.title,
        route: Routes.activity_show_path(socket, :show, session.id)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, "#{activity.title}")
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :activities)
     |> assign(:session, %{session | enrolled: Activities.get_total_enrolled(id)})
     |> assign(:activity, activity)
     |> assign(:enrolled?, maybe_put_enrolled(socket))
     |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(session.id))
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  @impl true
  def handle_event("enroll", _payload, socket) do
    case Activities.create_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {:ok, %Enrollment{}} ->
        {:noreply,
         socket
         |> put_flash(:success, "Enrolled successufully!")
         |> assign(:enrolled?, true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        case is_nil(changeset.errors[:session_id]) do
          true -> {:noreply, socket |> put_flash(:error, "Unable to enroll")}
          _ -> {:noreply, socket |> put_flash(:error, changeset.errors[:session_id] |> elem(0))}
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
     |> push_redirect(to: Routes.user_session_path(socket, :new))}
  end

  @impl true
  def handle_info({event, _changes}, socket)
      when event in [:new_enrollment, :deleted_enrollment] do
    {:noreply, reload(socket)}
  end

  defp reload(socket) do
    socket
    |> assign(:enrolled?, maybe_put_enrolled(socket))
    |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(socket.assigns.id))
  end

  defp maybe_put_enrolled(socket) when not socket.assigns.is_authenticated?, do: false

  defp maybe_put_enrolled(socket) do
    Activities.is_participating?(socket.assigns.id, socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket)
       when not is_map_key(socket.assigns, :current_organization) or
              is_nil(socket.assigns.current_organization) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id)
  end

  defp has_permissions?(socket) do
    Accounts.has_master_permissions?(socket.assigns.current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        socket.assigns.current_user.id,
        socket.assigns.current_organization.id
      )
  end
end
