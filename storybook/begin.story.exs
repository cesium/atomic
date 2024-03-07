defmodule Storybook.Begin do
  use PhoenixStorybook.Story, :page

  def doc, do: "Set of reusable components used in the Atomic platform by CeSIUM."

  def render(assigns) do
    ~H"""
    <div class="mt-8 select-none">
      <div class="flex items-center justify-center gap-8">
        <img class="w-48" src="/images/atomic.svg" />
        <p class="text-5xl font-semibold text-zinc-400 sm:text-7xl">Atomic</p>
      </div>
    </div>
    """
  end
end
