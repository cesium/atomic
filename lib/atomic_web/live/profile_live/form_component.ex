defmodule AtomicWeb.ProfileLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Accounts

  @extensions_whitelist ~w(.jpg .jpeg .gif .png .pdf .docx)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:cv, accept: @extensions_whitelist, max_entries: 1)
     |> allow_upload(:picture, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user = socket.assigns.user

    flash_text =
      if user_params["email"] != user.email do
        case Accounts.apply_user_email(user, %{email: user_params["email"]}) do
          {:ok, applied_user} ->
            Accounts.deliver_update_email_instructions(
              applied_user,
              user.email,
              &Routes.profile_edit_url(socket, :confirm_email, &1)
            )

            "Profile updated successfully, please check your email to confirm the new address."
        end
      else
        "Profile updated successfully."
      end

    case Accounts.update_user(
           user,
           Map.put(user_params, "email", user.email),
           &consume_cv_data(socket, &1),
           &consume_image_data(socket, &1)
         ) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, flash_text)
         |> push_navigate(to: Routes.profile_show_path(socket, :show, user_params["slug"]))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp consume_image_data(socket, user) do
    if Map.has_key?(socket.assigns.uploads, :image) do
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        Accounts.update_user_picture(user, %{
          "image" => %Plug.Upload{
            content_type: entry.client_type,
            filename: entry.client_name,
            path: path
          }
        })
      end)
      |> case do
        [{:ok, user}] ->
          {:ok, user}

        _errors ->
          {:ok, user}
      end
    end

    {:ok, user}
  end

  defp consume_cv_data(socket, user) do
    if Map.has_key?(socket.assigns.uploads, :cv) do
      consume_uploaded_entries(socket, :cv, fn %{path: path}, entry ->
        Accounts.update_user_cv(user, %{
          "cv" => %Plug.Upload{
            content_type: entry.client_type,
            filename: entry.client_name,
            path: path
          }
        })
      end)
      |> case do
        [{:ok, user}] ->
          {:ok, user}

        _errors ->
          {:ok, user}
      end
    end

    {:ok, user}
  end
end
