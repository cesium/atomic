defmodule AtomicWeb.Storybook.Components.Gradient do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Gradient

  def function, do: &Gradient.gradient/1

  def template do
    """
    <div class="w-52 h-52">
      <.lsb-variation/>
    </div>
    """
  end

  def variations do
    [
      %Variation{
        id: :random
      },
      %Variation{
        id: :predictable,
        attributes: %{
          seed: "CAOS"
        }
      }
    ]
  end
end
