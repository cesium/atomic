defmodule AtomicWeb.RedeemLive.FormComponent do
  @moduledoc false
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias Atomic.Activities

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:activity, assigns.activity)
     |> assign(:user, assigns.user)
     |> assign(:changeset, nil)}
  end

  @impl true
  def handle_event("save", __params, socket) do
    confirm_participation(
      socket,
      socket.assigns.current_user,
      socket.assigns.user,
      socket.assigns.activity
    )
  end

  defp confirm_participation(socket, _admin, user, activity) do
    enrollment = Activities.get_enrollment!(activity.id, user.id)

    case Activities.update_enrollment(enrollment, %{present: true}) do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign(:changeset, nil)
         |> redirect(to: Routes.scanner_index_path(socket, :index))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)}
    end
  end

  defp get_course(user) do
    case Accounts.get_course(user) do
      nil -> "No course"
      course -> course
    end
  end
end
