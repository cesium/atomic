defmodule AtomicWeb.ScannerLive.Index do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Activities

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
  """
  @impl true
  def handle_event("scan", pathname, socket) do
    [_, activity_id, user_id | _] = String.split(pathname, "/")
    activity = Activities.get_activity!(activity_id)

    if (socket.assigns.current_organization.id == activity.organization_id &&
          Accounts.has_permissions_inside_organization?(
            socket.assigns.current_user.id,
            socket.assigns.current_organization.id
          )) || Accounts.has_master_permissions?(socket.assigns.current_user) do
      confirm_participation(socket, activity_id, user_id)
    else
      {:noreply,
       socket
       |> put_flash(:error, "You are not authorized to this")
       |> redirect(to: Routes.scanner_index_path(socket, :index))}
    end
  end

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
