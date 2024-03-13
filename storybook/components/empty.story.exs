defmodule AtomicWeb.Storybook.Components.Empty do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Empty

  def function, do: &Empty.empty_state/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          placeholder: "item",
          url: "#"
        }
      }
    ]
  end
end
