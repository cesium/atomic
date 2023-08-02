defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:organizations, list_organizations())
     |> assign(:current_user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Organizations"),
        route: Routes.organization_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:current_page, :organizations)}
  end

  defp apply_action(socket, :show, %{"organization_id" => id}) do
    socket
    |> assign(:page_title, "Show Organization")
    |> assign(:organization, Organizations.get_organization!(id))
  end

  defp apply_action(socket, :edit, %{"organization_id" => id}) do
    socket
    |> assign(:page_title, "Edit Organization")
    |> assign(:organization, Organizations.get_organization!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organization")
    |> assign(:organization, %Organization{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Organizations")
    |> assign(:organization, nil)
  end

  @impl true
  def handle_event("delete", %{"organization_id" => id}, socket) do
    organization = Organizations.get_organization!(id)
    {:ok, _} = Organizations.delete_organization(organization)

    {:noreply, assign(socket, :organizations, list_organizations())}
  end

  defp list_organizations do
    Organizations.list_organizations()
  end

  def update_default_organization(user, organization) do
    Accounts.update_user(user, %{default_organization_id: organization.id})
  end
end
