defmodule AtomicWeb.LegalTermsLive.Components.Header do
  @moduledoc """
  Component for Legal Pages Header.
  """
  use Phoenix.Component
  use AtomicWeb, :component

  def header(assigns) do
    ~H"""
    <header class="fixed flex w-full place-items-center justify-between bg-white px-8 pt-8 pb-4">
      <div class="flex place-items-center gap-x-6 md:gap-x-12 lg:pl-12">
        <div class="flex place-items-center gap-x-4">
          <!-- Atomic Logo -->
          <.link navigate={~p"/"}>
            <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
          </.link>
          <!-- Section Name -->
          <p class="hidden select-none text-2xl font-semibold text-zinc-400 sm:block"><%= @page_name %></p>
        </div>
        <div class="flex hidden place-items-center gap-x-2 text-sm font-semibold text-zinc-300 sm:block sm:gap-x-4 sm:space-x-2 md:space-x-4">
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
        <.link class="atomic-button atomic-button--white atomic-button--md hidden sm:block" navigate={~p"/"}>Back home</.link>
        <.link class="atomic-button atomic-button--md hero-home block text-zinc-400 sm:hidden" navigate={~p"/"}></.link>
      </div>
    </header>
    """
  end
end
