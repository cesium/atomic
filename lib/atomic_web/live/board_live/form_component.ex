defmodule AtomicWeb.BoardLive.FormComponent do
  use AtomicWeb, :live_component

  # alias Atomic.Organizations
  alias Atomic.Board

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{organization_id: _org} = assigns, socket) do
    # changeset = Organizations.change_user_organization(user_organization)~

    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    changeset =
      socket.assigns.user_organization
      # |> Organizations.change_user_organization(user_organization_params)
      |> Board.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", board_params, socket) do
    # save_user_organization(socket, socket.assigns.action, user_organization_params)
    create_board(socket, board_params)
  end

  # defp save_user_organization(socket, :edit, user_organization_params) do
  #   case Organizations.update_user_organization(
  #          socket.assigns.user_organization,
  #          user_organization_params
  #        ) do
  #     {:ok, _organization} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Board updated successfully")
  #        |> push_navigate(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # defp save_user_organization(socket, :new, user_organization_params) do
  #   attrs =
  #     Map.put(
  #       user_organization_params,
  #       "organization_id",
  #       socket.assigns.organization_id
  #     )

  #   case Organizations.create_user_organization(attrs) do
  #     {:ok, _organization} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Board created successfully")
  #        |> push_navigate(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

  defp create_board(socket, board_params) do
    board_params = Map.put(board_params, "organization_id", socket.assigns.organization_id)

    case Board.create_board(board_params) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
