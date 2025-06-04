defmodule AtomicWeb.OrganizationLive.Components.PartnersGrid do
  @moduledoc """
  Internal organization-related component for displaying its partners.
  """
  use AtomicWeb, :component

  alias Atomic.Organizations.{Organization, Partner}
  alias Atomic.Repo
  import Ecto.Query

  attr :organization, Organization,
    required: true,
    doc: "The organization whose partners to display"

  def partners_grid(assigns) do
    ~H"""
    <div id="organization-partners" class="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-2">
      <%= for partner <- list_partners(@organization) do %>
        <.link navigate={~p"/organizations/#{@organization.id}/partners/#{partner.id}"}>
          <.partner_card partner={partner} />
        </.link>
      <% end %>
    </div>
    """
  end

  defp list_partners(%Organization{id: organization_id}) do
    from(p in Partner,
      where: p.organization_id == ^organization_id and not p.archived
    )
    |> Repo.all()
  end

  defp partner_card(assigns) do
    ~H"""
    <div class="rounded-2xl border bg-white p-4 shadow transition hover:shadow-md">
      <h3 class="text-lg font-semibold text-zinc-900"><%= @partner.name %></h3>
      <p class="mt-1 text-sm text-zinc-600"><%= @partner.location.name %></p>
      <p class="mt-2 line-clamp-3 text-sm text-zinc-500"><%= @partner.description %></p>
    </div>
    """
  end
end
