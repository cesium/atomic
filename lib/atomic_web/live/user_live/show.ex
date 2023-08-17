defmodule AtomicWeb.UserLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"handle" => user_handle}, _, socket) do
    user = Accounts.get_user_by_handle(user_handle)

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
    |> assign(:user, user)}
  end
end
