defmodule AtomicWeb.Storybook.Components.Badges do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Badge

  def function, do: &Badge.badge/1

  def variations do
    [
      %VariationGroup{
        id: :colors,
        description: "Different colors",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: "primary"
            },
            slots: [
              """
              <span>Primary</span>
              """
            ]
          },
          %Variation{
            id: :secondary,
            attributes: %{
              color: "secondary"
            },
            slots: [
              """
              <span>Secondary</span>
              """
            ]
          },
          %Variation{
            id: :info,
            attributes: %{
              color: "info"
            },
            slots: [
              """
              <span>Info</span>
              """
            ]
          },
          %Variation{
            id: :success,
            attributes: %{
              color: "success"
            },
            slots: [
              """
              <span>Success</span>
              """
            ]
          },
          %Variation{
            id: :warning,
            attributes: %{
              color: "warning"
            },
            slots: [
              """
              <span>Warning</span>
              """
            ]
          },
          %Variation{
            id: :danger,
            attributes: %{
              color: "danger"
            },
            slots: [
              """
              <span>Danger</span>
              """
            ]
          },
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
          }
        ]
      }
    ]
  end
end
