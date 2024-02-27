defmodule AtomicWeb.Storybook.Components.Badges do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Badges

  def function, do: &Badges.badge/1

  def variations do
  end
end
