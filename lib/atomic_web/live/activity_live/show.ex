defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Enrollment
  alias Atomic.Organizations

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
     |> assign(
       :enrolled?,
       Activities.is_participating?(id, socket.assigns.current_user.id)
     )
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :activities)
     |> assign(:session, %{session | enrolled: Activities.get_total_enrolled(id)})
     |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(session.id))
     |> assign(:activity, activity)}
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
        # FIXME: Improve error handling
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
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Activities.delete_activity(socket.assigns.activity)

    {:noreply,
     push_redirect(socket,
       to: Routes.activity_index_path(socket, :index)
     )}
  end

  @impl true
  def handle_info({event, _changes}, socket)
      when event in [:new_enrollment, :deleted_enrollment] do
    {:noreply, reload(socket)}
  end

  defp reload(socket) do
    socket
    |> assign(
      :enrolled?,
      Activities.is_participating?(socket.assigns.id, socket.assigns.current_user.id)
    )
    |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(socket.assigns.id))
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"
end
