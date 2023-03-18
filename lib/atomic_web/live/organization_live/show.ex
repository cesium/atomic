defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:organization, Organizations.get_organization!(id, [:departments]))}
  end

  @impl true
  def handle_event("sign_up", _payload, socket) do
    attrs = %{
      accepted: false,
      user_id: socket.assigns.current_user.id,
      organization_id: socket.assigns.organization.id
    }

    case Organizations.create_association(attrs) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:success, "Association created successfully")
         |> push_redirect(to: Routes.organization_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show), do: "Show Organization"
  defp page_title(:edit), do: "Edit Organization"
end
