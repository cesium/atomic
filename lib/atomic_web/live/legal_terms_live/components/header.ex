defmodule AtomicWeb.LegalTermsLive.Components.Header do
  @moduledoc """
  Component for Legal Pages Header.
  """
  use Phoenix.Component
  use AtomicWeb, :component

  @pages [
    {"Terms of Service", "tos"},
    {"Privacy Policy", "privacy"},
    {"Cookie Policy", "cookies"}
  ]

  defp link_pages(current_page) do
    Enum.map(@pages, fn {title, path} ->
      if title == current_page do
        {:current, title, path}
      else
        {:link, title, path}
      end
    end)
  end

  def header(assigns) do
    ~H"""
    <header class="max-w-[2000px] fixed flex w-full place-items-center justify-between bg-white pt-8 pr-8 pb-4 pl-4">
      <div class="flex place-items-center gap-x-6 md:gap-x-12 lg:pl-12">
        <div class="flex place-items-center gap-x-4">
          <!-- Atomic Logo -->
          <.link navigate={~p"/"}>
            <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
          </.link>
        </div>
        <div class="flex hidden place-items-center gap-x-2 text-sm font-semibold text-zinc-300 sm:block sm:gap-x-4 sm:space-x-2 md:space-x-4">
          <%= for {type, title, path} <- link_pages(@page_name) do %>
            <%= case type do %>
              <% :current -> %>
                <span class="text-lg text-zinc-400"><%= title %></span>
              <% :link -> %>
                <.link class="hover:text-zinc-400" navigate={"/" <> path}><%= title %></.link>
            <% end %>
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
