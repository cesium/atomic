defmodule AtomicWeb.LegalTermsLive.Components.MainTitle do
  use Phoenix.Component
  use AtomicWeb, :component

  def main_title(assigns) do
    ~H"""
    <section class="flex place-items-center align-center h-fit px-4 xl:px-12 py-40 pt-138">
      <span class="text-7xl sm:text-9xl text-zinc-800 font-semibold w-86 lg:w-8/12 2xl:w-2/5"><%= @page_title %></span>
    </section>
    """
  end
end
