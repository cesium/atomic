defmodule AtomicWeb.Components.Notification do
  @moduledoc false
  use AtomicWeb, :live_component

  alias Ecto.UUID

  @impl true
  def render(assigns) do
    notification_id = UUID.generate()

    ~H"""
    <div id={notification_id} x-init={"setTimeout(function() { document.getElementById('" <> notification_id <> "').remove(); }, 5000);"} class="flex w-full flex-col items-center space-y-4 sm:items-end">
      <div class="pointer-events-auto w-full max-w-sm overflow-hidden rounded-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5">
        <!-- Notification progress bar -->
        <.notification_progress type={@type} />
        <div class="p-4">
          <div class="flex items-start">
            <!-- Notification icon -->
            <div class="flex-shrink-0">
              <.notification_adornment type={@type} />
            </div>
            <div class="ml-3 w-0 flex-1 pt-0.5">
              <%= if is_binary(@message) do %>
                <p class="text-sm font-medium text-zinc-900">
                  <%= live_flash(@flash, @type) %>
                </p>
              <% else %>
                <p class="text-sm font-medium text-zinc-900">
                  <%= @message.title %>
                </p>
                <p class="mt-1 text-sm text-zinc-500">
                  <%= @message.description %>
                </p>
              <% end %>
            </div>
            <!-- Notification close button -->
            <div class="ml-4 flex flex-shrink-0">
              <button phx-click="lv:clear-flash" phx-value-key={@type} class="inline-flex rounded-md bg-white text-zinc-400 hover:text-zinc-500 focus:outline-none focus:ring-2 focus:ring-zinc-600 focus:ring-offset-2">
                <span class="sr-only">Close</span>
                <Heroicons.Solid.x class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp notification_adornment(assigns) do
    type = assigns.type

    case type do
      "info" ->
        ~H"""
        <Heroicons.Solid.information_circle class="h-6 w-6 text-blue-400" />
        """

      "success" ->
        ~H"""
        <Heroicons.Solid.check_circle class="h-6 w-6 text-green-400" />
        """

      "warning" ->
        ~H"""
        <Heroicons.Solid.exclamation class="h-6 w-6 text-yellow-400" />
        """

      "error" ->
        ~H"""
        <Heroicons.Solid.x_circle class="h-6 w-6 text-red-400" />
        """
    end
  end

  defp notification_progress(assigns) do
    type = assigns.type

    background_color =
      case type do
        "info" -> "bg-blue-400"
        "success" -> "bg-green-400"
        "warning" -> "bg-yellow-400"
        "error" -> "bg-red-400"
      end

    ~H"""
    <div class={background_color <> " opacity-100 h-[0.30rem] animate-progress"}></div>
    """
  end
end
