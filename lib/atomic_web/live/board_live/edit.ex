defmodule AtomicWeb.BoardLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _url, socket) do
    user_organization = Organizations.get_user_organization!(id, [:user, :organization])
    users = Enum.map(Accounts.list_users(), fn u -> [key: u.email, value: u.id] end)
    organization = user_organization.organization

    if user_organization.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action, organization))
       |> assign(:user_organization, user_organization)
       |> assign(:users, users)
       |> assign(:current_user, socket.assigns.current_user)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:index, organization), do: "#{organization.name} board"
  defp page_title(:show, organization), do: "#{organization.name} board"
  defp page_title(:edit, _), do: "Edit board"
end
