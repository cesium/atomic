defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.{Accounts, Organizations}

  import AtomicWeb.Components.{Forms, Pagination}
  import AtomicWeb.OrganizationLive.Components.OrganizationCard

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:form, to_form(%{"search" => ""}))
     |> assign(:query, "")}
  end

  @impl true
  def handle_params(params, _, socket) do
    %{organizations: organizations, meta: meta} = list_organizations(params, socket.assigns.query)

    {:noreply,
     socket
     |> assign(:page_title, "Organizations")
     |> assign(:current_page, :organizations)
     |> assign(:params, params)
     |> assign(:organizations, organizations)
     |> assign(:meta, meta)
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  @impl true
  def handle_event("search", %{"search" => query}, socket) do
    %{organizations: organizations, meta: meta} = list_organizations(socket.assigns.params, query)

    {:noreply,
     socket
     |> assign(:query, query)
     |> assign(:organizations, organizations)
     |> assign(:meta, meta)}
  end

  defp list_organizations(params, query) do
    params = Map.put(params, "page_size", 6)

    params =
      Map.put(params, "filters", %{
        filters: %{field: :name, op: :ilike, value: "%#{query}%"}
      })

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
