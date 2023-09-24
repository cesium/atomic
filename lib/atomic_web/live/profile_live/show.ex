defmodule AtomicWeb.ProfileLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Button

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => user_slug}, _, socket) do
    user = Accounts.get_user_by_slug(user_slug)

    is_current_user =
      Map.has_key?(socket.assigns, :current_user) and socket.assigns.current_user.id == user.id

    organizations = Organizations.list_user_organizations(user.id)

    {:noreply,
     socket
     |> assign(:page_title, user.name)
     |> assign(:current_page, :profile)
     |> assign(:user, user)
     |> assign(:organizations, organizations)
     |> assign(:is_current_user, is_current_user)}
  end
end
