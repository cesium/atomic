defmodule AtomicWeb.MembershipLive.New do
  @moduledoc false
  use AtomicWeb, :live_view

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Organizations.Membership

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, gettext("New Membership"))
     |> assign(:membership, %Membership{
       organization_id: organization_id
     })
     |> assign(:users, Enum.map(Accounts.list_users(), fn u -> [key: u.email, value: u.id] end))
     |> assign(
       :allowed_roles,
       Organizations.roles_less_than_or_equal(socket.assigns.current_user.role)
     )
     |> assign(:current_user, socket.assigns.current_user)}
  end
end
