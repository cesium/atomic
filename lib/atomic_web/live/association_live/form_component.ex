defmodule AtomicWeb.AssociationLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

  @impl true
  def update(%{association: association} = assigns, socket) do
    changeset = Organizations.change_association(association)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"association" => association_params}, socket) do
    changeset =
      socket.assigns.association
      |> Organizations.change_association(association_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"association" => association_params}, socket) do
    association_params = Map.put(association_params, "current_user", socket.assigns.current_user)

    update_association(
      socket,
      socket.assigns.action,
      association_params
    )
  end

  defp update_association(socket, :edit, association_params) do
    association = socket.assigns.association
    current_user = association_params["current_user"]
    number = association_params["number"]

    if association_params["accepted"] == "true" do
      if not number do
        {:noreply,
         socket
         |> put_flash(:error, "Number must be set")}
      else
        case Organizations.update_association(
               association,
               %{
                 accepted_by_id: current_user.id,
                 accepted: true,
                 number: number
               }
             ) do
          {:ok, _association} ->
            {:noreply,
             socket
             |> put_flash(:success, "Association updated successfully")
             |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end
      end
    else
      case Organizations.delete_association(association) do
        {:ok, _association} ->
          {:noreply,
           socket
           |> put_flash(:success, "Association deleted successfully")
           |> push_redirect(to: socket.assigns.return_to)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end
end
