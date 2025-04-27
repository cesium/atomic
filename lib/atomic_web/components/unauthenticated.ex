defmodule AtomicWeb.Components.Unauthenticated do
  @moduledoc """
  A component for displaying an unauthenticated state.
  """
  use AtomicWeb, :component

  attr :id, :string, default: "unauthenticated-state", required: false
  attr :url, :string, default: "users/log_in", required: false

  def unauthenticated_state(assigns) do
    ~H"""
    <div id={@id} class="text-center">
      <.icon name="hero-user-circle" class="mx-auto h-12 w-12 text-zinc-400" />
      <h3 class="mt-2 text-sm font-semibold text-zinc-900">{gettext("You are not authenticated")}</h3>
      <p class="mt-1 text-sm text-zinc-500">{gettext("Please log in to view this content.")}</p>
      <div class="mt-4 flex justify-center">
        <.button patch={@url} icon="hero-arrow-right-end-on-rectangle-solid" icon_position={:right}>
          {gettext("Log In")}
        </.button>
      </div>
    </div>
    """
  end
end
