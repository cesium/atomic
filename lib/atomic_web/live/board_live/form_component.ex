defmodule AtomicWeb.BoardLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{user_organization: user_organization} = assigns, socket) do
    changeset = Organizations.change_user_organization(user_organization)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_organization" => user_organization_params}, socket) do
    changeset =
      socket.assigns.user_organization
      |> Organizations.change_user_organization(user_organization_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user_organization" => user_organization_params}, socket) do
    save_user_organization(socket, socket.assigns.action, user_organization_params)
  end

  defp save_user_organization(socket, :edit, user_organization_params) do
    case Organizations.update_user_organization(
           socket.assigns.user_organization,
           user_organization_params
         ) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user_organization(socket, :new, user_organization_params) do
    attrs =
      Map.put(
        user_organization_params,
        "organization_id",
        socket.assigns.user_organization.organization_id
      )

    case Organizations.create_user_organization(attrs) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
