defmodule AtomicWeb.Components.MastersButtonModal do
  @moduledoc false

  use AtomicWeb, :live_component
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div>
      <.modal :if={@action} id="masters-modal" show on_cancel={JS.push("clear-action")}>
        <div class="flex flex-col gap-y-4">
          <h2 class="text-lg font-semibold leading-6 text-zinc-700"><%= gettext("Organizations") %></h2>
          <ul class="flex flex-col gap-y-2">
            <%= for organization <- @organizations do %>
              <li>
                <.link navigate={Routes.organization_path(AtomicWeb.Endpoint, :show, organization)} class="flex items-center gap-x-2 text-sm font-semibold leading-6 text-zinc-700">
                  <AtomicWeb.Components.Avatar.avatar name={organization.name} src={organization.logo} size={:xs} color={:light_gray} class="!text-sm" />
                  <span><%= organization.name %></span>
                </.link>
              </li>
            <% end %>
          </ul>
        </div>
      </.modal>
    </div>
    """
  end

  def handle_event("clear-action", _params, socket) do
    {:noreply, assign(socket, :action, false)}
  end

  def handle_event("update-action", _params, socket) do
    {:noreply, assign(socket, :action, true)}
  end
end
