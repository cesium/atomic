defmodule AtomicWeb.InstructorLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities

  @impl true
  def update(%{instructor: instructor} = assigns, socket) do
    changeset = Activities.change_instructor(instructor)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"instructor" => instructor_params}, socket) do
    changeset =
      socket.assigns.instructor
      |> Activities.change_instructor(instructor_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"instructor" => instructor_params}, socket) do
    save_instructor(socket, socket.assigns.action, instructor_params)
  end

  defp save_instructor(socket, :edit, instructor_params) do
    case Activities.update_instructor(socket.assigns.instructor, instructor_params) do
      {:ok, _instructor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Instructor updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_instructor(socket, :new, instructor_params) do
    case Activities.create_instructor(instructor_params) do
      {:ok, _instructor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Instructor created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
