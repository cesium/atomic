defmodule AtomicWeb.Storybook.Components.Icon do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Icon

  def function, do: &Icon.render/1

  def template do
    """
    <span class="h-8 w-8">
      <.lsb-variation/>
    </span>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          name: :academic_cap
        }
      },
      %Variation{
        id: :outline,
        description: "Outline",
        attributes: %{
          name: :academic_cap,
          outline: true
        }
      },
      %Variation{
        id: :solid,
        description: "Solid",
        attributes: %{
          name: :academic_cap,
          solid: true
        }
      },
      %Variation{
        id: :mini,
        description: "Mini",
        attributes: %{
          name: :academic_cap,
          mini: true
        }
      }
    ]
  end
end
