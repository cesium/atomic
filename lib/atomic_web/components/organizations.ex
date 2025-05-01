defmodule AtomicWeb.Components.Organizations do
  @moduledoc false
  use AtomicWeb, :live_component

  import AtomicWeb.Components.{Avatar, Accordion}

  alias Atomic.Accounts
  alias Atomic.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.accordion id={"#{@id}-accordion"} class="flex-grow rounded-md border" controlled={true}>
        <:trigger>
          <%= if @current_organization do %>
            <div class="group flex cursor-pointer gap-x-3 rounded-md p-2 text-sm font-semibold leading-6 text-zinc-700 hover:text-primary-500">
              <.avatar
                class={"#{(@current_organization && @current_organization.id == @current_organization.id) && "text-primary-600"} border border-zinc-200 group-hover:text-primary-500"}
                src={Uploaders.Logo.url({@current_organization.logo, @current_organization}, :original)}
                name={@current_organization.name}
                size={:xs}
                type={:organization}
                color={:white}
              />
              <span class="mt-1 truncate">{@current_organization.name}</span>
            </div>
          <% else %>
            <div class="group cursor-pointer gap-x-3 rounded-md p-2 text-left text-sm leading-6 text-zinc-600 hover:text-primary-500">
              <.icon name="hero-pencil-solid" class="size-5 shrink-0 text-zinc-400 group-hover:text-primary-500" />
              <span class="mt-1 truncate">{gettext("Pick an organization")}</span>
            </div>
          <% end %>
        </:trigger>
        <:panel>
          <ul role="list" class="mt-2 max-h-72 space-y-0.5 overflow-y-auto overscroll-contain p-1">
            <%= for organization <- @organizations do %>
              <li>
                <div
                  phx-target={@myself}
                  phx-click="select-organization"
                  phx-value-organization_id={organization.id}
                  class={
              "#{if @current_organization && organization.id == @current_organization.id do
                "bg-zinc-50 text-primary-500"
              else
                "text-zinc-700 hover:text-primary-500 hover:bg-zinc-50"
              end} group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold cursor-pointer"
            }
                  type="button"
                >
                  <.avatar
                    class={"#{(@current_organization && organization.id == @current_organization.id) && "text-primary-600"} border border-zinc-200 group-hover:text-primary-500"}
                    src={Uploaders.Logo.url({organization.logo, organization}, :original)}
                    name={organization.name}
                    size={:xs}
                    type={:organization}
                    color={:white}
                  />
                  <span class="mt-1 truncate">{organization.name}</span>
                </div>
              </li>
            <% end %>
          </ul>
        </:panel>
      </.accordion>
    </div>
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
       |> push_navigate(to: ~p"/")}
    else
      organization = Organizations.get_organization!(organization_id)

      Accounts.update_user(socket.assigns.current_user, %{
        current_organization_id: organization.id
      })

      {:noreply,
       socket
       |> assign(current_organization: organization)
       |> put_flash(:info, "#{gettext("Now editing as")} #{organization.name}")
       |> push_navigate(to: ~p"/organizations/#{organization}")}
    end
  end
end
