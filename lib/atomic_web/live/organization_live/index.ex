defmodule AtomicWeb.OrganizationLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.{Accounts, Organizations}

  import AtomicWeb.Components.{Dropdown, Forms, Pagination}
  import AtomicWeb.OrganizationLive.Components.OrganizationCard

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{}, as: "search")

    {:ok,
     socket
     |> assign(:form, form)
     |> assign(:query, "")}
  end

  @impl true
  def handle_params(params, _, socket) do
    %{organizations: organizations, meta: meta} = list_organizations(params, socket.assigns.query)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Organizations"))
     |> assign(:current_page, :organizations)
     |> assign(:params, params)
     |> stream(:organizations, organizations)
     |> assign(:meta, meta)
     |> assign(:has_permissions?, has_permissions?(socket))}
  end

  @impl true
  def handle_event("search", %{"search" => query}, socket) do
    %{organizations: organizations, meta: meta} = list_organizations(socket.assigns.params, query)

    {:noreply,
     socket
     |> assign(:query, query)
     |> stream(:organizations, organizations, reset: true)
     |> assign(:meta, meta)}
  end

  @impl true
  def handle_event("sort", %{"field" => field}, socket) do
    %{organizations: organizations, meta: meta} =
      list_organizations(socket.assigns.params, socket.assigns.query, field)

    {:noreply,
     socket
     |> stream(:organizations, organizations, reset: true)
     |> assign(:meta, meta)}
  end

  defp list_organizations(params, query, order \\ nil) do
    params = Map.put(params, "page_size", 6)

    params =
      Map.put(params, "filters", %{
        filters: %{field: :name, op: :ilike, value: query}
      })

    params = if order, do: Map.put(params, "order_by", [order]), else: params
    params = if order, do: Map.put(params, "order_directions", [:desc]), else: params

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
