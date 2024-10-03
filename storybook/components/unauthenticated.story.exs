defmodule AtomicWeb.Storybook.Components.Unauthenticated do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Unauthenticated

  def function, do: &Unauthenticated.unauthenticated_state/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{}
      }
    ]
  end
end
