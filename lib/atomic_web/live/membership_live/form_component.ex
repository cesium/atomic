defmodule AtomicWeb.MembershipLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

  @impl true
  def update(%{membership: membership} = assigns, socket) do
    changeset = Organizations.change_membership(membership)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"membership" => membership_params}, socket) do
    changeset =
      socket.assigns.membership
      |> Organizations.change_membership(membership_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"membership" => membership_params}, socket) do
    membership_params = Map.put(membership_params, "current_user", socket.assigns.current_user)

    update_membership(
      socket,
      socket.assigns.action,
      membership_params
    )
  end

  defp update_membership(socket, :edit, membership_params) do
    membership = socket.assigns.membership
    current_user = membership_params["current_user"]
    number = membership_params["number"]
    role = membership_params["role"]

    case Organizations.update_membership(
           membership,
           %{
             created_by_id: current_user.id,
             number: number,
             role: role
           }
         ) do
      {:ok, _membership} ->
        {:noreply,
         socket
         |> put_flash(:success, "membership updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp update_membership(socket, :new, membership_params) do
    org_id = socket.assigns.membership.organization_id
    current_user = membership_params["current_user"]
    number = membership_params["number"]
    role = membership_params["role"]
    user_id = membership_params["user_id"]

    case Organizations.create_membership(%{
           created_by_id: current_user.id,
           number: number,
           role: role,
           organization_id: org_id,
           user_id: user_id
         }) do
      {:ok, _membership} ->
        {:noreply,
         socket
         |> put_flash(:success, "membership created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
