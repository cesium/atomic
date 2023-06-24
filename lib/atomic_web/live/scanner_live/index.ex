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
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:title, "Scanner")}
  end

  @impl true
  def handle_event("scan", pathname, socket) do
    confirm_participation(socket, socket.assigns.current_user, pathname)
  end

  defp confirm_participation(socket, _admin, pathname) do
    string_split = String.split(pathname, "/")
    activity = Activities.get_activity!(string_split |> Enum.at(1))
    user = Accounts.get_user!(string_split |> Enum.at(2))

    case Activities.update_enrollment(Activities.get_enrollment!(activity.id, user.id), %{
           present: true
         }) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:success, "Participation confirmed!")
         |> assign(:changeset, nil)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Unable to confirm participation")
         |> assign(:changeset, changeset)}
    end
  end
end
