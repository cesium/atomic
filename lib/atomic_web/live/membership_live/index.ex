defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  import AtomicWeb.Components.Pagination
  import AtomicWeb.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => id} = params, _, socket) do
    organization = Organizations.get_organization!(id)

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
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
     |> assign(:params, params)
     |> assign(list_memberships(id, params))}
  end

  defp list_memberships(id, params) do
    case Organizations.list_memberships(params,
           where: [organization_id: id],
           preloads: [:user, :created_by]
         ) do
      {:ok, {memberships, meta}} ->
        %{memberships: memberships, meta: meta}

      {:error, flop} ->
        %{memberships: [], meta: flop}
    end
  end

  defp page_title(:index, organization), do: "#{organization.name}'s Memberships"
  defp page_title(:show, organization), do: "#{organization.name}'s Membership"
  defp page_title(:edit, _), do: "Edit membership"
end
