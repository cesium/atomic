defmodule AtomicWeb.LegalTermsLive.Components.BlackBar do
  use Phoenix.Component
  use AtomicWeb, :component

  def black_bar(assigns) do
    ~H"""
    <section class="flex justify-center bg-zinc-800 p-10 font-semibold text-white">
      <p class="flex w-full justify-center md:w-2/3">
        Lorem ipsum dolor sit amet.
      </p>
    </section>
    """
  end
end
