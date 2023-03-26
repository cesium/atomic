defmodule AtomicWeb.PartnerLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Partnerships
  alias Atomic.Partnerships.Partner

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :partnerships, list_partnerships())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Activities"),
        route: Routes.activity_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :partnerships)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Partner")
    |> assign(:partner, Partnerships.get_partner!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Partner")
    |> assign(:partner, %Partner{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Partnerships")
    |> assign(:partner, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    partner = Partnerships.get_partner!(id)
    {:ok, _} = Partnerships.delete_partner(partner)

    {:noreply, assign(socket, :partnerships, list_partnerships())}
  end

  defp list_partnerships do
    Partnerships.list_partnerships()
  end
end
