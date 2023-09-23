defmodule AtomicWeb.ScannerLive.Index do
  @moduledoc false

  use AtomicWeb, :live_view
  alias Atomic.Activities
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:title, "Scanner")}
  end

  @doc """
  Handles the scan event.
    Basically it does two checks:
      1) Verifies if current_organization is in organizations that are related to the session of the activity.
      2) Verifies if current_user is admin or owner of the organization, or , if current_user is admin of the system.

    If 1) and 2) are true, then confirm_participation is called.
    Else a flash message is shown and the user is redirected to the scanner index.
  """
  @impl true
  def handle_event("scan", pathname, socket) do
    [_, activity_id, user_id | _] = String.split(pathname, "/")

    activity = Activities.get_activity!(activity_id)

    if (socket.assigns.current_organization.id == activity.organization_id &&
          Organizations.get_role(
            socket.assigns.current_user.id,
            socket.assigns.current_organization.id
          ) in [:admin, :owner]) or socket.assigns.current_user.role in [:admin] do
      confirm_participation(socket, activity_id, user_id)
    else
      {:noreply,
       socket
       |> put_flash(:error, "You are not authorized to this")
       |> redirect(to: Routes.scanner_index_path(socket, :index))}
    end
  end

  # Updates the enrollment of the user in the session, setting present to true.
  #  If the update is successful, a flash message is shown and the user is redirected to the scanner index.
  #  Else a flash message is shown and the user is redirected to the scanner index.
  defp confirm_participation(socket, session_id, user_id) do
    case Activities.update_enrollment(Activities.get_enrollment!(session_id, user_id), %{
           present: true
         }) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:success, "Participation confirmed!")
         |> assign(:changeset, nil)
         |> redirect(to: Routes.scanner_index_path(socket, :index))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Unable to confirm participation")
         |> assign(:changeset, changeset)}
    end
  end
end
