defmodule AtomicWeb.Components.Organizations do
  @moduledoc false
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <li>
      <%= if count_user_organizations(@current_user.id) != 0 do %>
        <div class="text-xs font-semibold leading-6 text-zinc-400">Your organizations</div>
        <ul role="list" class="-mx-2 mt-2 space-y-1">
          <%= for organization <- Atomic.Organizations.list_user_organizations(@current_user.id) do %>
            <li>
              <div
                phx-target={@myself}
                phx-click="select-organization"
                phx-value-organization_id={organization.id}
                class={
                  "#{if @current_organization && organization.id == @current_organization.id do
                    "bg-zinc-50 text-orange-600"
                  else
                    "text-zinc-700 hover:text-orange-600 hover:bg-zinc-50"
                  end} group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold cursor-pointer"
                }
                type="button"
              >
                <span class="text-[0.625rem] flex h-8 w-8 shrink-0 items-center justify-center rounded-lg border border-zinc-200 bg-white font-medium text-zinc-400 group-hover:border-orange-600 group-hover:text-orange-600">
                  <%= if organization.logo do %>
                    <img src={Uploaders.Logo.url({organization.logo, organization}, :original)} class="h-6 w-6 rounded-lg" />
                  <% else %>
                    <%= extract_initials(organization.name) %>
                  <% end %>
                </span>
                <span class="mt-1 truncate"><%= organization.name %></span>
              </div>
            </li>
          <% end %>
        </ul>
      <% end %>
    </li>
    """
  end

  @impl true
  def handle_event("select-organization", %{"organization_id" => organization_id}, socket) do
    if socket.assigns.current_organization &&
         socket.assigns.current_organization.id == organization_id do
      Accounts.update_user(socket.assigns.current_user, %{current_organization_id: nil})

      {:noreply,
       socket
       |> assign(current_organization: nil)
       |> put_flash(:info, "Now viewing as yourself")
       |> push_redirect(to: Routes.home_index_path(socket, :index))}
    else
      organization = Organizations.get_organization!(organization_id)

      Accounts.update_user(socket.assigns.current_user, %{
        current_organization_id: organization.id
      })

      {:noreply,
       socket
       |> assign(current_organization: organization)
       |> put_flash(:info, "Now editing as #{organization.name}")
       |> push_redirect(to: Routes.organization_show_path(socket, :show, organization))}
    end
  end

  defp count_user_organizations(user_id) do
    Organizations.list_user_organizations(user_id)
    |> Enum.count()
  end
end
