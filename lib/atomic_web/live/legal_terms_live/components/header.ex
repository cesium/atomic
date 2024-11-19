defmodule AtomicWeb.LegalTermsLive.Components.Header do
  use Phoenix.Component
  use AtomicWeb, :component

  def header(assigns) do
    ~H"""
    <header class="w-full fixed flex bg-white place-items-center justify-between px-8 pt-8 pb-4">
        <div class="flex place-items-center gap-x-6 md:gap-x-12 lg:pl-12">
            <div class="flex place-items-center gap-x-4">
              <!-- Atomic Logo -->
              <.link navigate={~p"/"}>
                  <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
              </.link>
              <!-- Section Name -->
              <p class="hidden sm:block text-2xl font-semibold text-zinc-400 select-none"><%= @page_name %></p>
            </div>
            <div class="hidden sm:block flex place-items-center gap-x-2 sm:gap-x-4 sm:space-x-2 md:space-x-4 text-zinc-300 font-semibold text-sm">
            <%= if @page_name == "Terms of Service" do %>
              <.link class="hover:text-zinc-400" navigate={~p"/privacy"}>Privacy Policy</.link>
              <.link class="hover:text-zinc-400" navigate={~p"/cookies"}>Cookie Policy</.link>
            <% end %>
            <%= if @page_name == "Privacy Policy" do %>
              <.link class="hover:text-zinc-400" navigate={~p"/tos"}>Terms of Service</.link>
              <.link class="hover:text-zinc-400" navigate={~p"/cookies"}>Cookie Policy</.link>
            <% end %>
            <%= if @page_name == "Cookie Policy" do %>
              <.link class="hover:text-zinc-400" navigate={~p"/tos"}>Terms of Service</.link>
              <.link class="hover:text-zinc-400" navigate={~p"/privacy"}>Privacy Policy</.link>
            <% end %>
            </div>
        </div>
        <!-- Link to Home (hidden on mobile) -->
        <div class="flex place-items-center lg:pr-12">
            <.link class="hidden sm:block atomic-button atomic-button--white atomic-button--md" navigate={~p"/"}>Back home</.link>
            <.link class="block sm:hidden atomic-button atomic-button--md hero-home text-zinc-400" navigate={~p"/"}></.link>
        </div>
    </header>
    """
  end
end
