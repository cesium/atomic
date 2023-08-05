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
  def handle_params(_params, _url, socket) do
    entries = [
      %{
        name: gettext("Scanner"),
        route: Routes.scanner_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:title, "Scanner")
     |> assign(:breadcrumb_entries, entries)}
  end

  @impl true
  def handle_event("scan", pathname, socket) do
    [_, session_id, user_id | _] = String.split(pathname, "/")

    session = Activities.get_session!(session_id, [:activity])
    organizations = Activities.get_activity_organizations!(session.activity, [:departments])

    if (socket.assigns.current_organization.id in organizations &&
          Organizations.get_role(
            socket.assigns.current_user.id,
            socket.assigns.current_organization.id
          ) in [:admin, :owner]) or socket.assigns.current_user.role in [:admin] do
      confirm_participation(socket, session_id, user_id)
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
