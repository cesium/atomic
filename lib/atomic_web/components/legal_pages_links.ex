defmodule AtomicWeb.Components.LegalPagesLinks do
  @moduledoc """
  Contains the structure for the legal pages navigation
  """
  use AtomicWeb, :component

  def legal_pages_links(assigns) do
    ~H"""
    <div class="flex-colunm group mt-2 mb-4 flex w-full flex-wrap place-items-center justify-center gap-x-6 gap-y-1">
      <.link navigate={~p"/tos"} class="shrink-0 select-none">
        <p class="text-xs font-semibold text-zinc-400">Terms of Service</p>
      </.link>
      <.link navigate={~p"/privacy"} class="shrink-0 select-none">
        <p class="text-xs font-semibold text-zinc-400">Privacy Policy</p>
      </.link>
      <.link navigate={~p"/cookies"} class="shrink-0 select-none">
        <p class="text-xs font-semibold text-zinc-400">Cookie Policy</p>
      </.link>
      <span class="flex text-xs font-semibold text-zinc-400">&#169; 2024 CeSIUM</span>
    </div>
    """
  end
end
