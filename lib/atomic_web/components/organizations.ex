defmodule AtomicWeb.Components.Organizations do
  @moduledoc false
  use AtomicWeb, :live_component

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <ul role="list" class="-mx-2 mt-2 max-h-72 max-h-72 space-y-1 overflow-y-auto">
      <%= for organization <- @organizations do %>
        <li>
          <div
            phx-target={@myself}
            phx-click="select-organization"
            phx-value-organization_id={organization.id}
            class={
              "#{if @current_organization && organization.id == @current_organization.id do
                "bg-zinc-50 text-orange-500"
              else
                "text-zinc-700 hover:text-orange-500 hover:bg-zinc-50"
              end} group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold cursor-pointer"
            }
            type="button"
          >
            <span class="text-[0.625rem] flex h-8 w-8 shrink-0 items-center justify-center rounded-lg border border-zinc-200 font-medium text-zinc-400 group-hover:border-orange-500 group-hover:text-orange-500">
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
       |> put_flash(:info, gettext("Now viewing as yourself"))
       |> push_navigate(to: Routes.home_index_path(socket, :index))}
    else
      organization = Organizations.get_organization!(organization_id)

      Accounts.update_user(socket.assigns.current_user, %{
        current_organization_id: organization.id
      })

      {:noreply,
       socket
       |> assign(current_organization: organization)
       |> put_flash(:info, "#{gettext("Now editing as")} #{organization.name}")
       |> push_navigate(to: Routes.organization_show_path(socket, :show, organization))}
    end
  end
end
