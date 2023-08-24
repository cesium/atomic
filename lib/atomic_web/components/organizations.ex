defmodule AtomicWeb.Components.Organizations do
  @moduledoc """
  This component is used to render the list of organizations in the sidebar.
  """
  use Phoenix.LiveComponent

  alias Atomic.Accounts
  alias Atomic.Organizations
  alias Atomic.Uploaders.Logo

  def render(
        %{
          current_user: current_user,
          current_organization: current_organization
        } = assigns
      ) do
    ~H"""
    <div class="organizations">
      <%= for organization <- Accounts.get_user_organizations(current_user) do %>
        <%= if current_organization && organization.id != current_organization.id do %>
          <div role="none">
            <a phx-target={@myself} phx-click="default-organization" phx-value-organization_id={organization.id} class="w-full text-zinc-700 block px-4 py-2 text-sm hover:bg-zinc-200 focus:bg-zinc-300" role="menuitem" tabindex="-1" id="options-menu-item-0">
              <span class="flex w-full items-center justify-between">
                <span class="flex min-w-0 items-center justify-between space-x-3">
                  <%= if organization.logo do %>
                    <img src={Logo.url({organization.logo, organization}, :original)} class="w-10 h-10 rounded-lg" />
                  <% else %>
                    <span class="inline-flex justify-center items-center mr-1.5 w-10 h-10 bg-zinc-500 rounded-lg">
                      <span class="text-lg font-medium leading-none text-white">
                        <%= Atomic.Accounts.extract_initials(organization.name) %>
                      </span>
                    </span>
                  <% end %>
                  <span class="flex min-w-0 flex-1 flex-col">
                    <span class="truncate text-md font-medium text-zinc-900"></span>
                    <span class="truncate text-sm text-zinc-600">
                      <%= organization.name %>
                    </span>
                    <span class="truncate text-xs text-zinc-500">
                      <%= AtomicWeb.Helpers.capitalize_first_letter(Atomic.Organizations.get_role(current_user.id, organization.id)) %>
                    </span>
                  </span>
                </span>
              </span>
            </a>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("default-organization", %{"organization_id" => organization_id}, socket) do
    organization = Organizations.get_organization!(organization_id)
    user = socket.assigns.current_user

    case Accounts.update_user(user, %{default_organization_id: organization.id}) do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign(:current_organization, organization)
         |> redirect(to: "/")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was an error updating your current organization")}
    end
  end
end
