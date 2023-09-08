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

  def handle_params(%{"token" => token}, _, socket) do
    case Accounts.update_user_email(socket.assigns.current_user, token) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Email changed successfully.")
         |> redirect(to: Routes.profile_show_path(socket, :show, socket.assigns.current_user))}

      :error ->
        {:noreply,
         socket
         |> put_flash(:error, "Email change link is invalid or it has expired.")
         |> redirect(to: Routes.profile_show_path(socket, :show, socket.assigns.current_user))}
    end
  end
end
