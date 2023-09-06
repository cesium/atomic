defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Organizations
  alias AtomicWeb.MismatchError

  @impl true
  def mount(%{"slug" => slug, "id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe("new_enrollment")
      Activities.subscribe("deleted_enrollment")
    end

    {:ok,
     socket
     |> assign(:id, id)
     |> assign(:slug, slug)}
  end

  @impl true
  def handle_params(%{"slug" => slug, "id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:speakers, :departments])

    organizations = Activities.get_activity_organizations!(activity, [:departments])

    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index, slug)
      },
      %{
        name: activity.title,
        route: Routes.activity_show_path(socket, :show, slug, activity.id)
      }
    ]

    if slug in organizations do
      {:noreply,
       socket
       |> assign(
         :enrolled?,
         Activities.is_participating?(id, socket.assigns.current_user.id)
       )
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:breadcrumb_entries, entries)
       |> assign(:current_page, :activities)
       |> assign(:activity, %{activity | enrolled: Activities.get_total_enrolled(id)})
       |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(activity.id))}
    else
      raise MismatchError
    end
  end

  @impl true
  def handle_event("enroll", _payload, socket) do
    case Activities.create_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {:ok, _enrollment} ->
        {:noreply,
         socket
         |> put_flash(:success, "Enrolled successufully!")
         |> set_enrolled(socket.assigns.id, socket.assigns.current_user)}

      {:error, changeset} ->
        case is_nil(changeset.errors[:activity_id]) do
          true -> {:noreply, socket |> put_flash(:error, "Unable to enroll")}
          _ -> {:noreply, socket |> put_flash(:error, changeset.errors[:activity_id] |> elem(0))}
        end
    end
  end

  @impl true
  def handle_event("unenroll", _payload, socket) do
    activity_id = socket.assigns.id
    current_user = socket.assigns.current_user

    case Activities.delete_enrollment(activity_id, current_user) do
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
    activity = socket.assigns.activity

    if activity.id == enrollment.activity_id do
      {:noreply,
       assign(socket, :activity, %{
         activity
         | enrolled: Activities.get_total_enrolled(activity.id)
       })}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({event, _application}, socket) when event in [:deleted_application] do
    activity = socket.assigns.activity

    {:noreply,
     assign(socket, :activity, %{activity | enrolled: Activities.get_total_enrolled(activity.id)})}
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
      "https://#{Application.fetch_env!(:atomic, AtomicWeb.Endpoint)[:url][:host]}"
    end
  end
end
