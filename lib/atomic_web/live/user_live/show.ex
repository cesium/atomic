defmodule AtomicWeb.UserLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    entries = [
      %{
        name: gettext("Users"),
        route: Routes.user_show_path(socket, :show, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :users)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:user, Accounts.get_user!(id))}
  end
end
