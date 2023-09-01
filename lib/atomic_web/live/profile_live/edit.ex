defmodule AtomicWeb.ProfileLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => user_slug}, _, socket) do
    user = Accounts.get_user_by_slug(user_slug)

    entries = [
      %{
        name: gettext("%{name}", name: user.name),
        route: Routes.profile_show_path(socket, :show, user_slug)
      },
      %{
        name: gettext("Edit Profile", name: user.name),
        route: Routes.profile_edit_path(socket, :edit, user_slug)
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
