defmodule AtomicWeb.PartnerLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations
  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{partner: partner} = assigns, socket) do
    changeset = Organizations.change_partner(partner)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"partner" => partner_params}, socket) do
    changeset =
      socket.assigns.partner
      |> Organizations.change_partner(partner_params)
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
    case Organizations.update_partner(
           socket.assigns.partner,
           partner_params,
           &consume_image_data(socket, &1)
         ) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_partner(socket, :new, partner_params) do
    case Organizations.create_partner(partner_params, &consume_image_data(socket, &1)) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp consume_image_data(socket, partner) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
      Organizations.update_image(partner, %{
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
