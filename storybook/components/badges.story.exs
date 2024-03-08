defmodule AtomicWeb.Storybook.Components.Badges do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Badges

  def function, do: &Badges.badge_dot/1

  def variations do
    [
      %VariationGroup{
        id: :colors,
        description: "Different colors",
        variations: [
          %Variation{
            id: :gray,
            attributes: %{
              color: "gray"
            },
            slots: [
              """
              <span>Gray</span>
              """
            ]
          },
          %Variation{
            id: :red,
            attributes: %{
              color: "red"
            },
            slots: [
              """
              <span>Red</span>
              """
            ]
          },
          %Variation{
            id: :purple,
            attributes: %{
              color: "purple"
            },
            slots: [
              """
              <span>Purple</span>
              """
            ]
          }
        ]
      }
    ]
  end
end
