defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Activities.Session
  alias Atomic.Departments

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:departments, [])
     |> assign(:speakers, [])}
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    departments = Departments.list_departments_by_organization_id(assigns.organization.id)
    speakers = Activities.list_speakers_by_organization_id(assigns.organization.id)
    changeset = Activities.change_activity(activity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:departments, departments)
     |> assign(:speakers, speakers)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def update(%{"organization_id" => organization_id}, socket) do
    departments = Departments.list_departments_by_organization_id(organization_id)

    {:ok,
     socket
     |> assign(:departments, departments)}
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
        :sessions,
        socket.assigns.activity.sessions
      )

    sessions =
      existing_sessions
      |> Enum.concat([Activities.change_session(%Session{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:sessions, sessions)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-session", %{"index" => index}, socket) do
    new_sessions =
      Map.get(socket.assigns.changeset.changes, :sessions)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:sessions, new_sessions)

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
