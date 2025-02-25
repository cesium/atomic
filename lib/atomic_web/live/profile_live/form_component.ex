defmodule AtomicWeb.ProfileLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias AtomicWeb.Components.ImageUploader

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:profile_picture,
       accept: @extensions_whitelist,
       max_entries: 1,
       max_file_size: 10_000_000
     )
     |> allow_upload(:image_2,
       accept: @extensions_whitelist,
       max_entries: 1,
       max_file_size: 100_000_000
     )}
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

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    socket =
      case Enum.find(socket.assigns.uploads.profile_picture.entries, fn entry ->
             entry.ref == ref
           end) do
        nil -> socket
        _entry -> cancel_upload(socket, :profile_picture, ref)
      end

    socket =
      case Enum.find(socket.assigns.uploads.image_2.entries, fn entry -> entry.ref == ref end) do
        nil -> socket
        _entry -> cancel_upload(socket, :image_2, ref)
      end

    {:noreply, socket}
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
              &url(~p"/users/confirm_email/#{&1}")
            )

            "Profile updated successfully, please check your email to confirm the new address."
        end
      else
        "Profile updated successfully."
      end

    case Accounts.update_user(user, Map.put(user_params, "email", user.email)) do
      {:ok, user} ->
        case consume_image_data(socket, user) do
          {:ok, _user} ->
            {:noreply,
             socket
             |> put_flash(:success, flash_text)
             |> push_navigate(to: ~p"/profile/#{user_params["slug"]}")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end
    end
  end

  defp consume_image_data(socket, user) do
    consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, entry ->
      handle_image_upload(user, path, entry, :profile_picture)
    end)

    consume_uploaded_entries(socket, :image_2, fn %{path: path}, entry ->
      handle_image_upload(user, path, entry, :image_2)
    end)

    {:ok, user}
  end

  defp handle_image_upload(user, path, entry, field) do
    Accounts.update_user_picture(user, %{
      "#{field}" => %Plug.Upload{
        content_type: entry.client_type,
        filename: entry.client_name,
        path: path
      }
    })
    |> case do
      {:ok, user} ->
        {:ok, user}

      {:error, changeset} ->
        if changeset.errors[field] do
          {:postpone, "File size exceeds maximum allowed size"}
        else
          {:error, changeset}
        end

      {:errors, _changeset} ->
        {:error, "An error occurred while updating the user."}
    end
  end
end
