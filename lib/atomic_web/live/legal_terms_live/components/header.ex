defmodule AtomicWeb.LegalTermsLive.Components.Header do
  use Phoenix.Component
  use AtomicWeb, :component

  def header(assigns) do
    ~H"""
    <header class="w-full fixed flex bg-white justify-between px-8 pt-8 pb-4">
        <div class="flex place-items-center gap-x-4 lg:pl-12">
            <!-- Atomic Logo -->
            <.link navigate={~p"/"}>
                <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
            </.link>
            <!-- Section Name -->
            <p class="text-2xl font-semibold text-zinc-400 select-none"><%= @page_name %></p>
        </div>
        <!-- Link to Home (hidden on mobile) -->
        <div class="flex place-items-center hidden sm:block lg:pr-12">
            <.link class="atomic-button atomic-button--white atomic-button--md" navigate={~p"/"}>Back home</.link>
        </div>
    </header>
    """
  end
end
