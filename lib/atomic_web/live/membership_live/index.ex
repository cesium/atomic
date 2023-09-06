defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Organizations

  import AtomicWeb.Helpers
  import AtomicWeb.Components.Pagination
  import AtomicWeb.Components.Table

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, socket) do
    organization = Organizations.get_organization_by_slug(slug)

    entries = [
      %{
        name: gettext("Memberships"),
        route: Routes.membership_index_path(socket, :index, slug)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :memberships)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action, organization))
     |> assign(list_memberships(organization.id))}
  end

  defp list_memberships(id, params \\ %{}) do
    abc =
      Organizations.list_display_memberships(Map.put(params, "page_size", 9),
        where: [organization_id: id],
        preloads: [:user, :created_by]
      )

    case abc do
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
