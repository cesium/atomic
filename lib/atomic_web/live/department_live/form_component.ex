defmodule AtomicWeb.DepartmentLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Departments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@changeset} id="department-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <div class="flex flex-col gap-y-8">
          <div class="flex flex-col gap-y-1">
            <div>
              <%= label(f, :name, class: "text-sm font-semibold") %>
              <p class="text-xs text-gray-500">The name of the department</p>
            </div>
            <%= text_input(f, :name, class: "focus:ring-primary-500 focus:border-primary-500") %>
            <%= error_tag(f, :name) %>
          </div>

          <div class="flex flex-col gap-y-1">
            <div>
              <%= label(f, :description, class: "text-sm font-semibold") %>
              <p class="text-xs text-gray-500">A brief description of the department</p>
            </div>
            <%= text_input(f, :description, class: "focus:ring-primary-500 focus:border-primary-500") %>
            <%= error_tag(f, :description) %>
          </div>

          <div class="align-center flex">
            <%= checkbox(f, :collaborator_applications, class: "text-primary-500 my-auto focus:ring-primary-500 focus:border-primary-500") %>
            <div class="ml-4">
              <%= label(f, :collaborator_applications, class: "text-sm font-semibold") %>
              <p class="text-xs text-gray-500">Allow any user to apply to be a collaborator in this department</p>
            </div>
            <%= error_tag(f, :collaborator_applications) %>
          </div>

          <div class="mt-8 flex w-full justify-end">
            <.button size={:md} color={:white} icon={:cube}>Save Changes</.button>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{department: department} = assigns, socket) do
    changeset = Departments.change_department(department)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"department" => department_params}, socket) do
    changeset =
      socket.assigns.department
      |> Departments.change_department(department_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"department" => department_params}, socket) do
    save_department(socket, socket.assigns.action, department_params)
  end

  defp save_department(socket, :edit, department_params) do
    case Departments.update_department(socket.assigns.department, department_params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_department(socket, :new, department_params) do
    department_params =
      Map.put(department_params, "organization_id", socket.assigns.organization.id)

    case Departments.create_department(department_params) do
      {:ok, _department} ->
        {:noreply,
         socket
         |> put_flash(:info, "Department created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
