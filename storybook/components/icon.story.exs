defmodule AtomicWeb.Storybook.Components.Icon do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Icon

  def function, do: &Icon.icon/1

  def template do
    """
    <span class="size-8">
      <.lsb-variation />
    </span>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          name: "hero-academic-cap"
        }
      },
      %Variation{
        id: :outline,
        description: "Outline",
        attributes: %{
          name: "hero-academic-cap"
        }
      },
      %Variation{
        id: :solid,
        description: "Solid",
        attributes: %{
          name: "hero-academic-cap-solid"
        }
      },
      %Variation{
        id: :mini,
        description: "Mini",
        attributes: %{
          name: "hero-academic-cap-mini"
        }
      },
      %Variation{
        id: :micro,
        description: "Micro",
        attributes: %{
          name: "hero-academic-cap-micro"
        }
      }
    ]
  end
end
