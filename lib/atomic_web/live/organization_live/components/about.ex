defmodule AtomicWeb.OrganizationLive.Components.About do
  @moduledoc false
  use AtomicWeb, :component

  alias Atomic.Organizations.Organization
  alias Atomic.Socials

  attr :organization, Organization, required: true, doc: "the organization which about to display"

  def about(assigns) do
    ~H"""
    <div id="organization-about">
      <h2 class="mb-2 flex-1 select-none truncate text-lg font-semibold text-zinc-900"><%= gettext("Description") %></h2>
      <p><%= @organization.description %></p>

      <div :if={@organization.location}>
        <h2 class="mt-8 mb-2 flex-1 select-none truncate text-lg font-semibold text-zinc-900"><%= gettext("Location") %></h2>
        <p class="text-zinc-900"><%= @organization.location %></p>
      </div>

      <div :if={@organization.socials}>
        <h2 class="mt-8 mb-2 flex-1 select-none truncate text-lg font-semibold text-zinc-900"><%= gettext("Socials") %></h2>

        <ul role="list" class="flex flex-col space-y-2 md:flex-row md:items-center md:space-x-6 md:space-y-0">
          <li :if={@organization.socials.website}>
            <.link href={@organization.socials.website} target="_blank" class="group flex items-center space-x-1">
              <.icon name="hero-link" outline class="size-4" />
              <p class="group-hover:underline"><%= @organization.socials.website %></p>
            </.link>
          </li>

          <li :if={@organization.socials.facebook}>
            <.link href={Socials.link(:facebook, @organization.socials.facebook)} target="_blank" class="group flex items-center space-x-1">
              <%= Socials.icon(:facebook) |> raw() %>
              <p class="group-hover:underline"><%= @organization.socials.facebook %></p>
            </.link>
          </li>

          <li :if={@organization.socials.instagram}>
            <.link href={Socials.link(:instagram, @organization.socials.instagram)} target="_blank" class="group flex items-center space-x-1">
              <%= Socials.icon(:instagram) |> raw() %>
              <p class="group-hover:underline"><%= @organization.socials.instagram %></p>
            </.link>
          </li>

          <li :if={@organization.socials.x}>
            <.link href={Socials.link(:x, @organization.socials.x)} target="_blank" class="group flex items-center space-x-1">
              <%= Socials.icon(:x) |> raw() %>
              <p class="group-hover:underline"><%= @organization.socials.x %></p>
            </.link>
          </li>

          <li :if={@organization.socials.linkedin}>
            <.link href={Socials.link(:linkedin, @organization.socials.linkedin)} target="_blank" class="group flex items-center space-x-1">
              <%= Socials.icon(:linkedin) |> raw() %>
              <p class="group-hover:underline"><%= @organization.socials.linkedin %></p>
            </.link>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
