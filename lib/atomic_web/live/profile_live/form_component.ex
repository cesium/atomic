defmodule AtomicWeb.ProfileLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Accounts

  import AtomicWeb.Components.Forms
  import AtomicWeb.Components.{Button, Avatar}
  import AtomicWeb.Components.ImageUploader

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
     |> allow_upload(:banner,
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
    uploads = [:profile_picture, :banner]

    socket =
      Enum.reduce(uploads, socket, fn key, acc ->
        if Enum.any?(Map.get(acc.assigns.uploads, key, %{entries: []}).entries, &(&1.ref == ref)) do
          cancel_upload(acc, key, ref)
        else
          acc
        end
      end)

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
    results =
      [:profile_picture, :banner]
      |> Enum.map(fn field ->
        consume_uploaded_entries(socket, field, fn %{path: path}, entry ->
          case Accounts.update_user_picture(user, %{
            "#{field}" => %Plug.Upload{
              content_type: entry.client_type,
              filename: entry.client_name,
              path: path
            }
          }) do
            {:ok, updated_user} -> {:ok, updated_user}
            {:error, _changeset} -> {:error, field}
          end
        end)
      end)
      |> List.flatten()

    if Enum.any?(results, fn result -> match?({:error, _}, result) end) do
      {:error, results}
    else
      {:ok, user}
    end
  end

end
