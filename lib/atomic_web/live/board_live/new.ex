defmodule AtomicWeb.BoardLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Organizations.UserOrganization
  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"org" => org_id}, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("New Board"))
     |> assign(:user_organization, %UserOrganization{
       organization_id: org_id
     })
     |> assign(:users, Enum.map(Accounts.list_users(), fn u -> [key: u.email, value: u.id] end))
     |> assign(:current_user, socket.assigns.current_user)}
  end
end
