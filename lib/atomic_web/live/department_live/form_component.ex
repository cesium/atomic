defmodule AtomicWeb.DepartmentLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Departments
  alias AtomicWeb.Components.ImageUploader

  import AtomicWeb.Components.Forms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@changeset} id="department-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <h2 class="mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("General") %></h2>
        <div>
          <.field type="text" help_text="The name of the department" field={f[:name]} placeholder="Name" required />
          <.field type="textarea" help_text="A brief description of the department" field={f[:description]} placeholder="Description" />
          <.field type="checkbox" help_text="Allow any user to apply to be a collaborator in this department" field={f[:collaborator_applications]} />
        </div>
        <h2 class="mt-8 mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("Personalization") %></h2>
        <div class="w-full gap-y-1">
          <div>
            <%= label(f, :banner, class: "text-sm font-semibold") %>
            <p class="mb-2 text-xs text-gray-500">The banner of the department</p>
          </div>
          <div>
            <.live_component module={ImageUploader} id="uploader" uploads={@uploads} target={@myself} />
          </div>
        </div>

        <div class="mt-8 flex w-full justify-end">
          <.button size={:md} color={:white} icon={:cube}>Save Changes</.button>
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
     |> allow_upload(:image, accept: Atomic.Uploader.extensions_whitelist(), max_entries: 1)
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
