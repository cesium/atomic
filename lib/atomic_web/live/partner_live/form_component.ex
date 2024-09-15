defmodule AtomicWeb.PartnerLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Partners
  alias AtomicWeb.Components.ImageUploader
  import AtomicWeb.Components.Forms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@changeset} id="partner-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <h2 class="teaxt-lg mb-2 w-full border-b pb-2 font-semibold text-gray-900"><%= gettext("General") %></h2>
        <div class="flex flex-col gap-y-8">
          <div class="flex flex-col gap-y-1">
            <.field type="text" help_text={gettext("The name of the partner")} field={f[:name]} placeholder="Name" required />
            <.field type="text" help_text={gettext("A brief description of the partner")} field={f[:description]} placeholder="Description" required />
            <.field type="textarea" help_text={gettext("Benefits of the partnership")} field={f[:benefits]} placeholder="Benefits" required />
            <.inputs_for :let={location_form} field={f[:location]}>
              <.field field={location_form[:name]} label="Address" type="text" placeholder="Address" help_text={gettext("Address of the partner")} required />
            </.inputs_for>
            <h2 class="mt-8 mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("Socials") %></h2>
            <div class="grid w-full gap-x-4 sm:grid-cols-1 md:grid-cols-4 lg:grid-cols-4">
              <.inputs_for :let={socials_form} field={f[:socials]}>
                <.field field={socials_form[:instagram]} type="text" class="w-full" />
                <.field field={socials_form[:facebook]} type="text" class="w-full" />
                <.field field={socials_form[:x]} type="text" class="w-full" />
                <.field field={socials_form[:website]} type="text" class="w-full" />
              </.inputs_for>
            </div>
          </div>
        </div>
        <h2 class="mt-8 mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("Personalization") %></h2>
        <div class="w-full gap-y-1">
          <div>
            <%= label(f, :image) %>
            <p class="atomic-form-help-text pb-4"><%= gettext("The image of the partner (960x960px for best display)") %></p>
          </div>
          <div>
            <.live_component module={ImageUploader} id="uploader" uploads={@uploads} target={@myself} />
          </div>
        </div>
        <h2 class="mt-8 mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("Internal") %></h2>
        <div class="w-full gap-y-1">
          <.field type="textarea" field={f[:notes]} placeholder="Notes" />
        </div>
        <div class="mt-8 flex w-full justify-end">
          <.button size={:md} color={:white} icon="hero-cube">Save Changes</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{partner: partner} = assigns, socket) do
    changeset = Partners.change_partner(partner)

    {:ok,
     socket
     |> allow_upload(:image, accept: Uploaders.PartnerImage.extension_whitelist(), max_entries: 1)
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"partner" => partner_params}, socket) do
    changeset =
      socket.assigns.partner
      |> Partners.change_partner(partner_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("cancel-image", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  def handle_event("save", %{"partner" => partner_params}, socket) do
    save_partner(socket, socket.assigns.action, partner_params)
  end

  defp save_partner(socket, :edit, partner_params) do
    case Partners.update_partner(
           socket.assigns.partner,
           partner_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_partner(socket, :new, partner_params) do
    organization_id = socket.assigns.organization.id
    partner_params = Map.put(partner_params, "organization_id", organization_id)

    case Partners.create_partner(partner_params, &consume_image_data(socket, &1)) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp consume_image_data(socket, partner) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Partners.update_partner_picture(partner, %{
        "image" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, partner}] ->
        {:ok, partner}

      _errors ->
        {:ok, partner}
    end
  end
end
