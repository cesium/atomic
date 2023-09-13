defmodule AtomicWeb.UserLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.Button

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"handle" => user_handle}, _, socket) do
    user = Accounts.get_user_by_handle(user_handle)

    is_current_user =
      Map.has_key?(socket.assigns, :current_user) and socket.assigns.current_user.id == user.id

    organizations = Organizations.list_user_organizations(user.id)

    entries = [
      %{
        name: gettext("%{name}", name: user.name),
        route: Routes.user_show_path(socket, :show, user_handle)
      }
    ]

    {:noreply,
     socket
     |> assign(:page_title, user.name)
     |> assign(:current_page, :profile)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:user, user)
     |> assign(:organizations, organizations)
     |> assign(:is_current_user, is_current_user)}
  end
end
