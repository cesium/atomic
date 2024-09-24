defmodule AtomicWeb.ProfileLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias AtomicWeb.Components.ImageUploader
  import AtomicWeb.Components.Forms

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-4 pt-4">
      <.form :let={f} for={@changeset} id="profile-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <!-- Grid layout for profile picture, name, phone number, email, and social media fields -->
        <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
          <!-- Section for profile picture upload -->
          <div class="flex flex-col items-center">
            <%= label(f, :name, "Profile Picture", class: "mt-3 mb-1 text-sm font-medium text-gray-700") %>
            <!-- Profile picture upload (with square shape) -->
            <div class="rounded-lg">
              <.live_component module={ImageUploader} id="uploader-profile-picture" uploads={@uploads} target={@myself} />
            </div>
          </div>

          <div class="flex flex-col gap-6">
            <!-- Name, phone number, email fields -->
            <div class="grid grid-cols-1 gap-4">
              <.field field={f[:name]} type="text" placeholder="Name" class="w-full" />
              <.field field={f[:phone_number]} type="text" placeholder="Phone Number" class="w-full" />
              <.field field={f[:email]} type="email" placeholder="Email" class="w-full" />
            </div>
            <!-- Social media fields positioned below name, phone, and email -->
            <div class="grid w-full gap-x-4 gap-y-4 sm:grid-cols-1 md:grid-cols-4">
              <.inputs_for :let={socials_form} field={f[:socials]}>
                <.field field={socials_form[:instagram]} type="text" placeholder="Instagram" class="w-full" />
                <.field field={socials_form[:facebook]} type="text" placeholder="Facebook" class="w-full" />
                <.field field={socials_form[:x]} type="text" placeholder="X" class="w-full" />
                <.field field={socials_form[:tiktok]} type="text" placeholder="TikTok" class="w-full" />
              </.inputs_for>
            </div>
          </div>
        </div>
        <!-- Submit button -->
        <div class="mt-8 flex w-full justify-end">
          <.button size={:md} color={:white} icon="hero-cube">Save</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image,
       accept: Uploaders.ProfilePicture.extension_whitelist(),
       max_entries: 1
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

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
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
           &consume_image_data(socket, &1)
         ) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, flash_text)
         |> push_navigate(
           to:
             Routes.profile_show_path(
               socket,
               :show,
               user_params["slug"] || socket.assigns.user.slug
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp consume_image_data(socket, user) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Accounts.update_user_picture(user, %{
        "profile_picture" => %Plug.Upload{
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
end
