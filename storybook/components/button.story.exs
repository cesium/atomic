defmodule AtomicWeb.Storybook.Components.Button do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Button

  def function, do: &Button.button/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          """
          <span>Default</span>
          """
        ]
      },
      %Variation{
        id: :outline,
        attributes: %{
          variant: :outline,
          fg_color: "orange-500",
          bg_color_hover: "gray-200"
        },
        slots: [
          """
          <span>Default</span>
          """
        ]
      },
      %Variation{
        id: :custom_color,
        attributes: %{
          bg_color: "white",
          bg_color_hover: "gray-50",
          fg_color: "gray-300",
          class: "border border-gray-300 font-medium"
        },
        slots: [
          """
          <span>Default</span>
          """
        ]
      },
      %Variation{
        id: :icon,
        attributes: %{
          icon: :cake
        },
        slots: [
          """
          <span>With Icon</span>
          """
        ]
      },
      %VariationGroup{
        id: :icon_position,
        description: "Icon positioning",
        variations: [
          %Variation{
            id: :icon_left,
            attributes: %{
              icon: :code_bracket,
              icon_position: :left
            },
            slots: [
              """
              <span>On the Left!</span>
              """
            ]
          },
          %Variation{
            id: :icon_right,
            attributes: %{
              icon: :code_bracket,
              icon_position: :right
            },
            slots: [
              """
              <span>On the Right!</span>
              """
            ]
          }
        ]
      },
      %Variation{
        id: :spinner,
        attributes: %{
          spinner: true,
          bg_color: "white",
          bg_color_hover: "gray-50",
          fg_color: "gray-300",
          class: "border border-gray-300 font-medium"
        },
        slots: [
          """
          <span>Default</span>
          """
        ]
      },
      %Variation{
        id: :full_width,
        attributes: %{
          full_width: true
        },
        slots: [
          """
          <span>Full Width</span>
          """
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Different sizes",
        variations: [
          %Variation{
            id: :extra_small,
            attributes: %{
              size: :xs
            },
            slots: [
              """
              <span>Extra Small</span>
              """
            ]
          },
          %Variation{
            id: :small,
            attributes: %{
              size: :sm
            },
            slots: [
              """
              <span>Small</span>
              """
            ]
          },
          %Variation{
            id: :medium,
            attributes: %{
              size: :md
            },
            slots: [
              """
              <span>Medium</span>
              """
            ]
          },
          %Variation{
            id: :large,
            attributes: %{
              size: :lg
            },
            slots: [
              """
              <span>Large</span>
              """
            ]
          },
          %Variation{
            id: :extra_large,
            attributes: %{
              size: :xl
            },
            slots: [
              """
              <span>Extra Large</span>
              """
            ]
          }
        ]
      }
    ]
  end
end
