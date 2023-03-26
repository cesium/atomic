defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Activities.Session
  alias Atomic.Organizations

  @impl true
  def mount(socket) do
    departments = Organizations.list_departments()
    speakers = Activities.list_speakers()

    {:ok,
     socket
     |> assign(:departments, departments)
     |> assign(:speakers, speakers)}
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    changeset = Activities.change_activity(activity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"activity" => activity_params}, socket) do
    save_activity(socket, socket.assigns.action, activity_params)
  end

  def handle_event("add-session", _, socket) do
    existing_sessions =
      Map.get(
        socket.assigns.changeset.changes,
        :activity_sessions,
        socket.assigns.activity.activity_sessions
      )

    sessions =
      existing_sessions
      |> Enum.concat([Activities.change_session(%Session{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:activity_sessions, sessions)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-session", %{"index" => index}, socket) do
    new_sessions =
      Map.get(socket.assigns.changeset.changes, :activity_sessions)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:activity_sessions, new_sessions)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_activity(socket, :edit, activity_params) do
    case Activities.update_activity(socket.assigns.activity, activity_params) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    case Activities.create_activity(activity_params) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
