defmodule AtomicWeb.DepartmentLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

  @impl true
  def update(%{department: department} = assigns, socket) do
    changeset = Organizations.change_department(department)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"department" => department_params}, socket) do
    changeset =
      socket.assigns.department
      |> Organizations.change_department(department_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"department" => department_params}, socket) do
    save_department(socket, socket.assigns.action, department_params)
  end

  defp save_department(socket, :edit, department_params) do
    case Organizations.update_department(socket.assigns.department, department_params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_department(socket, :new, department_params) do
    case Organizations.create_department(department_params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
