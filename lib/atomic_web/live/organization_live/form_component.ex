defmodule AtomicWeb.OrganizationLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Organizations

  @impl true
  def mount(socket) do
    speakers = Activities.list_speakers()

    {:ok,
     socket
     |> allow_upload(:card, accept: Atomic.Uploader.extensions_whitelist(), max_entries: 1)
     |> assign(:speakers, speakers)}
  end

  @impl true
  def update(%{organization: organization} = assigns, socket) do
    changeset = Organizations.change_organization(organization)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"organization" => organization_params}, socket) do
    changeset =
      socket.assigns.organization
      |> Organizations.change_organization(organization_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"organization" => organization_params}, socket) do
    save_organization(socket, socket.assigns.action, organization_params)
  end

  defp save_organization(socket, :edit, organization_params) do
    consume_card_data(socket, socket.assigns.organization)

    case Organizations.update_organization(socket.assigns.organization, organization_params) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_organization(socket, :new, organization_params) do
    case Organizations.create_organization(organization_params) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp consume_card_data(socket, organization) do
    consume_uploaded_entries(socket, :card, fn %{path: path}, entry ->
      Organizations.update_card_image(organization, %{
        "card_image" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, organization}] ->
        {:ok, organization}

      _errors ->
        {:ok, organization}
    end
  end
end
