defmodule AtomicWeb.Components.MastersButton do
  @moduledoc false

  use AtomicWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.button color={:white} size={:sm} navigate="" class="w-56" phx-click="update-action" phx-target={@myself}>
        <.icon name={:plus} class="h-5 w-5" />
        <span class="ml-2 text-sm font-semibold leading-6"><%= gettext("View an organization") %></span>
      </.button>
    </div>
    """
  end

  @impl true
  def handle_event("update-action", _params, socket) do
    {:noreply, assign(socket, :action, true)}
  end
end
