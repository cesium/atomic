defmodule AtomicWeb.OrganizationLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations
  alias Atomic.Departments
  alias Atomic.Activities
  alias Atomic.Repo

  @impl true
  def mount(socket) do
    departments = Departments.list_departments()
    speakers = Activities.list_speakers()

    {:ok,
     socket
     |> assign(:speakers, speakers)
     |> assign(:departments, departments)}
  end

  @impl true
  def update(%{organization: organization} = assigns, socket) do
    organization = organization |> Repo.preload(:departments)
    changeset = Organizations.change_organization(organization)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"organization" => organization_params}, socket) do
    changeset =
      socket.assigns.organization
      |> Repo.preload(:departments)
      |> Organizations.change_organization(organization_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"organization" => organization_params}, socket) do
    save_organization(socket, socket.assigns.action, organization_params)
  end

  defp save_organization(socket, :edit, organization_params) do
    case Organizations.update_organization(socket.assigns.organization, organization_params) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_organization(socket, :new, organization_params) do
    case Organizations.create_organization(organization_params) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
