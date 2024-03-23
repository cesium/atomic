defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.{Accounts, Organizations}
  alias Phoenix.LiveView.JS

  import AtomicWeb.Components.{Forms, Pagination}
  import AtomicWeb.OrganizationLive.Components.OrganizationCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    %{organizations: organizations, meta: meta} = list_organizations(params)

    {:noreply,
     socket
     |> assign(:page_title, "Organizations")
     |> assign(:current_page, :organizations)
     |> assign(:params, params)
     |> assign(:meta, meta)
     |> assign(:organizations, organizations)
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  defp list_organizations(params) do
    params = Map.put(params, "page_size", 6)

    case Organizations.list_organizations(params) do
      {:ok, {organizations, meta}} ->
        %{organizations: organizations, meta: meta}

      {:error, flop} ->
        %{organizations: [], meta: flop}
    end
  end

  defp has_permissions?(socket) when not socket.assigns.is_authenticated?, do: false

  defp has_permissions?(socket),
    do: Accounts.has_master_permissions?(socket.assigns.current_user.id)
end
