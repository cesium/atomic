defmodule AtomicWeb.MembershipLive.Index do
  use AtomicWeb, :live_view

  import AtomicWeb.Helpers
  import AtomicWeb.Components.Pagination
  import AtomicWeb.Components.Table
  import AtomicWeb.Components.Dropdown

  alias Atomic.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_name" => organization_name} = params, _, socket) do
    organization = Organizations.get_organization_by_name!(organization_name)

    {:noreply,
     socket
     |> assign(:page_title, "#{organization.name}'s #{gettext("Memberships")}")
     |> assign(:current_page, :memberships)
     |> assign(:params, params)
     |> assign(list_memberships(organization.id, params))}
  end

  defp list_memberships(id, params) do
    case Organizations.list_display_memberships(Map.put(params, "page_size", 9),
           where: [organization_id: id],
           preloads: [:user, :created_by]
         ) do
      {:ok, {memberships, meta}} ->
        %{memberships: memberships, meta: meta}

      {:error, flop} ->
        %{memberships: [], meta: flop}
    end
  end
end
