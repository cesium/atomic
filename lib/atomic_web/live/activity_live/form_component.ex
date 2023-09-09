defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Departments

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    changeset = Activities.change_activity(activity)

    current_organization = assigns.current_organization
    departments = Departments.list_departments_by_organization_id(current_organization.id)
    speakers = Activities.list_speakers_by_organization_id(current_organization.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:departments, departments)
     |> assign(:speakers, speakers)
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
