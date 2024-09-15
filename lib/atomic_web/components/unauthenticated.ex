defmodule AtomicWeb.Components.Unauthenticated do
  @moduledoc """
  A component for displaying an unauthenticated state.
  """
  use AtomicWeb, :component

  attr :id, :string, default: "unauthenticated-state", required: false
  attr :url, :string, default: "users/sign_in", required: false

  def unauthenticated_state(assigns) do
    ~H"""
    <div id={@id} class="text-center">
      <.icon name="hero-user-circle" class="mx-auto h-12 w-12 text-zinc-400" />
      <h3 class="mt-2 text-sm font-semibold text-zinc-900">You are not authenticated</h3>
      <p class="mt-1 text-sm text-zinc-500">Please sign in to view this content.</p>
      <div class="mt-4">
        <.link
          navigate={Routes.user_session_path(AtomicWeb.Endpoint, :new)}
          class="inline-flex items-center rounded-md bg-orange-500 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-orange-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-orange-500"
        >
          <span class="mr-2 text-sm font-semibold leading-6" aria-hidden="true">Sign in</span>
          <.icon name="hero-arrow-right-end-on-rectangle-solid" class="size-5" />
        </.link>
      </div>
    </div>
    """
  end
end
