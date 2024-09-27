defmodule AtomicWeb.ActivityLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Avatar, Dropdown, Gradient, Map}

  alias Atomic.Accounts
  alias Atomic.Activities
  alias Atomic.Activities.Enrollment
  alias Phoenix.LiveView.JS

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Activities.subscribe_to_activity_update(id)
    end

    {:ok, socket |> assign(:id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    activity = Activities.get_activity!(id, [:organization])

    {:noreply,
     socket
     |> assign(:page_title, "#{activity.title}")
     |> assign(:current_page, :activities)
     |> assign(:activity, activity)
     |> assign(:participants, Activities.list_activity_participants(id))
     |> assign(:enrolled?, maybe_put_enrolled(socket))
     |> assign(:enrollment_id, maybe_put_enrollment_id(socket))
     |> assign(:max_enrolled?, Activities.verify_maximum_enrollments?(id))
     |> then(fn complete_socket ->
       assign(complete_socket, :has_permissions?, has_permissions?(complete_socket))
     end)}
  end

  @impl true
  def handle_event("confirm", _payload, socket) do
    case socket.assigns.live_action do
      :enroll ->
        action_enroll(socket)

      :unenroll ->
        action_unenroll(socket)

      _ ->
        {:noreply, socket}
    end
  end

  def action_enroll(socket) do
    case Activities.create_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {:ok, %Enrollment{}} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Enrolled successufully!"))
         |> assign(:enrolled?, true)
         |> push_patch(to: Routes.activity_show_path(socket, :show, socket.assigns.activity))}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("Unable to enroll. Please try again later."))
         |> push_patch(to: Routes.activity_show_path(socket, :show, socket.assigns.activity))}
    end
  end

  def action_unenroll(socket) do
    case Activities.delete_enrollment(socket.assigns.id, socket.assigns.current_user) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:success, "Unenrolled successufully!")
         |> assign(:enrolled?, false)
         |> push_patch(to: Routes.activity_show_path(socket, :show, socket.assigns.activity))}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("Unable to unenroll. Please try again."))
         |> push_patch(to: Routes.activity_show_path(socket, :show, socket.assigns.activity))}
    end
  end

  @impl true
  def handle_info(updated_activity, socket) do
    max_enrolled? = updated_activity.enrolled >= updated_activity.maximum_entries

    {:noreply,
     socket
     |> assign(
       :activity,
       Map.put(updated_activity, :organization, socket.assigns.activity.organization)
     )
     |> assign(:enrolled?, maybe_put_enrolled(socket))
     |> assign(:max_enrolled?, max_enrolled?)
     |> maybe_close_modal(max_enrolled? and socket.assigns.live_action == :enroll)}
  end

  defp maybe_close_modal(socket, condition) do
    if condition do
      push_patch(socket, to: Routes.activity_show_path(socket, :show, socket.assigns.activity))
    else
      socket
    end
  end

  defp maybe_put_enrollment_id(socket) when not socket.assigns.is_authenticated?, do: nil

  defp maybe_put_enrollment_id(socket) do
    Activities.get_enrollment!(socket.assigns.id, socket.assigns.current_user.id)
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

  def draw_ticket_qr_code(enrollment_id) do
    enrollment_id = enrollment_id.id

    enrollment_id
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#111827", width: 200, background_color: :transparent)
  end

  defp build_url do
    if Mix.env() == :dev do
      "http://localhost:4000"
    else
      "https://#{Application.fetch_env!(:atomic, AtomicWeb.Endpoint)[:url][:host]}"
    end
  end

  defp generate_dropdown_items(is_enrolled, can_edit, activity, socket) do
    [%{name: gettext("Share"), link: "/", icon: :share}]
    |> append_if_true(is_enrolled, %{
      name: gettext("Unenroll"),
      link: Routes.activity_show_path(socket, :unenroll, activity),
      icon: :user_minus
    })
    |> append_if_true(can_edit, %{
      name: gettext("Edit"),
      link: Routes.activity_edit_path(socket, :edit, activity.organization, activity),
      icon: :pencil
    })
  end

  defp append_if_true(list, true, item), do: list ++ [item]
  defp append_if_true(list, _, _), do: list

  defp display_action_goal_confirm_title(action) do
    case action do
      :enroll ->
        gettext("Are you sure you want to join this activity?")

      :unenroll ->
        gettext("Are you sure you no longer want to take part in this activity?")
    end
  end

  defp display_action_goal_confirm_description(action) do
    case action do
      :enroll ->
        gettext("You can alway unenroll later if you change your mind.")

      :unenroll ->
        gettext("Beware that you will lose your spot if you unenroll.")
    end
  end
end
