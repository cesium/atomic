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
        id: :hero_outline,
        description: "Heroicon outline",
        attributes: %{
          name: "hero-academic-cap"
        }
      },
      %Variation{
        id: :hero_solid,
        description: "Heroicon solid",
        attributes: %{
          name: "hero-academic-cap-solid"
        }
      },
      %Variation{
        id: :hero_mini,
        description: "Heroicon mini",
        attributes: %{
          name: "hero-academic-cap-mini"
        }
      },
      %Variation{
        id: :hero_micro,
        description: "Heroicon micro",
        attributes: %{
          name: "hero-academic-cap-micro"
        }
      },
      %Variation{
        id: :tabler_outline,
        description: "Tabler outline",
        attributes: %{
          name: "tabler-affiliate"
        }
      },
      %Variation{
        id: :tabler_filled,
        description: "Tabler filled",
        attributes: %{
          name: "tabler-affiliate-filled"
        }
      }
    ]
  end
end
