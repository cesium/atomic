defmodule AtomicWeb.OrganizationLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    organization = Organizations.get_organization!(id, [:departments])

    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.speaker_index_path(socket, :index)
      },
      %{
        name: organization.name,
        route: Routes.organization_show_path(socket, :show, id)
      }
    ]

    org = Organizations.get_organization!(id, [:departments])

    {:noreply,
     socket
     |> assign(:current_page, organization.name)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:breadcrumb_entries, entries)
     |> assign(:organization, Organizations.get_organization!(id, [:departments]))
     |> assign(:organization, org)
     |> assign(:following, Organizations.is_member_of?(socket.assigns.current_user, org))}
  end

  @impl true
  def handle_event("follow", _payload, socket) do
    attrs = %{
      role: :follower,
      user_id: socket.assigns.current_user.id,
      created_by_id: socket.assigns.current_user.id,
      organization_id: socket.assigns.organization.id
    }

    case Organizations.create_membership(attrs) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> put_flash(:success, "Started following " <> socket.assigns.organization.name)
         |> push_redirect(to: Routes.organization_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show), do: "Show Organization"
  defp page_title(:edit), do: "Edit Organization"
end
