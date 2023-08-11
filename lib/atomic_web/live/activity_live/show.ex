defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Organizations
  alias AtomicWeb.MismatchError

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe("new_enrollment")
      Activities.subscribe("deleted_enrollment")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    session = Activities.get_session!(id, [:activity, :speakers, :departments])

    activity = Activities.get_activity!(session.activity_id, [:activity_sessions])

    organizations = Activities.get_session_organizations!(session, [:departments])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, organization_id)
      },
      %{
        name: activity.title,
        route: Routes.activity_show_path(socket, :show, organization_id, session.id)
      }
    ]

    if organization_id in organizations do
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
       |> assign(:activity, activity)}
    else
      raise MismatchError
    end
  end

  @impl true
  def handle_event("enroll", _payload, socket) do
    session_id = socket.assigns.id
    current_user = socket.assigns.current_user

    case Activities.create_enrollment(session_id, current_user) do
      {:ok, _enrollment} ->
        {:noreply,
         socket
         |> put_flash(:success, "Enrolled successufully!")
         |> set_enrolled(session_id, current_user)}

      {:error, _error} ->
        {:noreply,
         socket
         |> put_flash(:error, "Unable to enroll")
         |> set_enrolled(session_id, current_user)}
    end
  end

  @impl true
  def handle_event("unenroll", _payload, socket) do
    session_id = socket.assigns.id
    current_user = socket.assigns.current_user

    case Activities.delete_enrollment(session_id, current_user) do
      {1, nil} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Unenrolled successufully!"))
         |> assign(:enrolled?, false)}

      {_, nil} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("Unable to unenroll"))}
    end
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Activities.delete_activity(socket.assigns.activity)

    {:noreply,
     push_redirect(socket,
       to: Routes.activity_index_path(socket, :index, socket.assigns.current_organization)
     )}
  end

  @impl true
  def handle_info({event, enrollment}, socket) when event in [:new_enrollment] do
    session = socket.assigns.session

    if session.id == enrollment.session_id do
      {:noreply,
       assign(socket, :session, %{session | enrolled: Activities.get_total_enrolled(session.id)})}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({event, _application}, socket) when event in [:deleted_application] do
    session = socket.assigns.session

    {:noreply,
     assign(socket, :session, %{session | enrolled: Activities.get_total_enrolled(session.id)})}
  end

  defp draw_qr_code(activity, user, _socket) do
    internal_route = "/redeem/#{activity.id}/#{user.id}/confirm"

    url = build_url() <> internal_route

    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"

  defp set_enrolled(socket, session_id, current_user) do
    Activities.get_user_enrolled(current_user, session_id)

    {:noreply, socket}
  end

  defp build_url do
    if Mix.env() == :dev do
      "http://localhost:4000"
    else
      "https://#{Application.fetch_env(:atomic, AtomicWeb.Endpoint)[:url][:host]}"
    end
  end

  def is_admin?(user, session) do
    department = session.departments |> Enum.at(0)
    Organizations.get_role(user.id, department.organization_id) in [:admin, :owner]
  end
end
