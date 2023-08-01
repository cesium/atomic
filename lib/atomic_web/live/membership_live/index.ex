defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => id}, _, socket) do
    memberships =
      Organizations.list_memberships(%{"organization_id" => id}, [:user])
      |> Enum.filter(fn m -> m.role != :follower end)

    entries = [
      %{
        name: gettext("Memberships"),
        route: Routes.membership_index_path(socket, :index, id)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :memberships)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:memberships, memberships)}
  end

  defp page_title(:index), do: "List memberships"
  defp page_title(:show), do: "Show membership"
  defp page_title(:edit), do: "Edit membership"
end
