defmodule AtomicWeb.UserLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:profile_picture, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", %{"user" => _user_params}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    update_user(
      socket,
      socket.assigns.action,
      user_params
    )
  end

  defp update_user(socket, :edit, user_params) do
    user = socket.assigns.user

    consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, entry ->
      Accounts.update_user_picture(user, %{
        "profile_picture" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
