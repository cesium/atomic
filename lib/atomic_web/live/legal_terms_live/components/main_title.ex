defmodule AtomicWeb.LegalTermsLive.Components.MainTitle do
  @moduledoc """
  Component for Legal Pages Main Title.
  """
  use Phoenix.Component
  use AtomicWeb, :component

  def main_title(assigns) do
    ~H"""
    <section class="align-center pt-138 flex h-fit place-items-center px-4 py-40 xl:px-12">
      <span class="w-86 text-7xl font-semibold text-zinc-800 sm:text-9xl lg:w-8/12 2xl:w-2/5"><%= @page_title %></span>
    </section>
    """
  end
end
