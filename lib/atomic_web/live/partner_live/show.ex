defmodule AtomicWeb.PartnerLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Partnerships
  alias Atomic.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id, "id" => id}, _, socket) do
    partner = Partnerships.get_partner!(id)

    entries = [
      %{
        name: gettext("Partners"),
        route: Routes.partner_index_path(socket, :index, organization_id)
      },
      %{
        name: gettext("%{name}", name: partner.name),
        route: Routes.partner_show_path(socket, :show, organization_id, id)
      }
    ]

    if partner.organization_id == organization_id do
      {:noreply,
       socket
       |> assign(:current_page, :partners)
       |> assign(:page_title, page_title(socket.assigns.live_action, partner.name))
       |> assign(:breadcrumb_entries, entries)
       |> assign(:partner, partner)}
    else
      raise AtomicWeb.MismatchError
    end
  end

  defp page_title(:show, partner), do: "#{partner}"
  defp page_title(:edit, partner), do: "Edit #{partner}"
end
