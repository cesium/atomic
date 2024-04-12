defmodule AtomicWeb.PartnerLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Partners
  alias AtomicWeb.Components.ImageUploader

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@changeset} id="partner-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <h2 class="mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("General") %></h2>
        <div class="flex flex-col gap-y-8">
          <div class="flex flex-col gap-y-1">
            <div>
              <%= label(f, :name, class: "text-sm font-semibold") %>
              <p class="text-xs text-gray-500">The name of the partner</p>
            </div>
            <%= text_input(f, :name, class: "focus:ring-primary-500 focus:border-primary-500") %>
            <%= error_tag(f, :name) %>
          </div>
          <div class="flex flex-col gap-y-1">
            <div>
              <%= label(f, :description, class: "text-sm font-semibold") %>
              <p class="text-xs text-gray-500">A brief description of the partner</p>
            </div>
            <%= text_input(f, :description, class: "focus:ring-primary-500 focus:border-primary-500") %>
            <%= error_tag(f, :description) %>
          </div>
        </div>
        <h2 class="mt-8 mb-2 w-full border-b pb-2 text-lg font-semibold text-gray-900"><%= gettext("Personalization") %></h2>
        <div class="w-full gap-y-1">
          <div>
            <%= label(f, :banner, class: "text-sm font-semibold") %>
            <p class="mb-2 text-xs text-gray-500">The banner of the partner</p>
          </div>
          <div>
            <.live_component module={ImageUploader} id="uploader" uploads={@uploads} target={@myself} />
          </div>
        </div>
        <div class="mt-8 flex w-full justify-end">
          <.button size={:md} color={:white} icon={:cube}>Save Changes</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: Atomic.Uploader.extensions_whitelist(), max_entries: 1)}
  end

  @impl true
  def update(%{partner: partner} = assigns, socket) do
    changeset = Partners.change_partner(partner)

    {:ok,
     socket
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
    partner_params = Map.put(partner_params, "organization_id", socket.assigns.organization.id)

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
      Partners.update_partner(partner, %{
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
