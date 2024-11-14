defmodule AtomicWeb.Storybook.Components.Button do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Button

  def function, do: &Button.button/1

  def template do
    """
    <div class="flex flex-wrap items-end justify-center gap-4 px-4 py-8 mt-5 md:px-8">
      <.lsb-variation-group/>
    </div>
    """
  end

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
      %VariationGroup{
        id: :color,
        description: "Colors",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: :primary
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
              color: :secondary
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
              color: :info
            },
            slots: [
              """
              <span>Information</span>
              """
            ]
          },
          %Variation{
            id: :success,
            attributes: %{
              color: :success
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
              color: :warning
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
              color: :danger
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
              color: :gray
            },
            slots: [
              """
              <span>Gray</span>
              """
            ]
          },
          %Variation{
            id: :pure_white,
            attributes: %{
              color: :pure_white
            },
            slots: [
              """
              <span>Pure White</span>
              """
            ]
          },
          %Variation{
            id: :white,
            attributes: %{
              color: :white
            },
            slots: [
              """
              <span>White</span>
              """
            ]
          },
          %Variation{
            id: :light,
            attributes: %{
              color: :light
            },
            slots: [
              """
              <span>Light</span>
              """
            ]
          },
          %Variation{
            id: :dark,
            attributes: %{
              color: :dark
            },
            slots: [
              """
              <span>Dark</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :outline,
        description: "Outline",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: :primary,
              variant: :outline
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
              color: :secondary,
              variant: :outline
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
              color: :info,
              variant: :outline
            },
            slots: [
              """
              <span>Information</span>
              """
            ]
          },
          %Variation{
            id: :success,
            attributes: %{
              color: :success,
              variant: :outline
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
              color: :warning,
              variant: :outline
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
              color: :danger,
              variant: :outline
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
              color: :gray,
              variant: :outline
            },
            slots: [
              """
              <span>Gray</span>
              """
            ]
          },
          %Variation{
            id: :pure_white,
            attributes: %{
              color: :pure_white,
              variant: :outline
            },
            slots: [
              """
              <span>Pure White</span>
              """
            ]
          },
          %Variation{
            id: :white,
            attributes: %{
              color: :white,
              variant: :outline
            },
            slots: [
              """
              <span>White</span>
              """
            ]
          },
          %Variation{
            id: :light,
            attributes: %{
              color: :light,
              variant: :outline
            },
            slots: [
              """
              <span>Light</span>
              """
            ]
          },
          %Variation{
            id: :dark,
            attributes: %{
              color: :dark,
              variant: :outline
            },
            slots: [
              """
              <span>Dark</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :inverted,
        description: "Inverted",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: :primary,
              variant: :inverted
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
              color: :secondary,
              variant: :inverted
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
              color: :info,
              variant: :inverted
            },
            slots: [
              """
              <span>Information</span>
              """
            ]
          },
          %Variation{
            id: :success,
            attributes: %{
              color: :success,
              variant: :inverted
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
              color: :warning,
              variant: :inverted
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
              color: :danger,
              variant: :inverted
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
              color: :gray,
              variant: :inverted
            },
            slots: [
              """
              <span>Gray</span>
              """
            ]
          },
          %Variation{
            id: :pure_white,
            attributes: %{
              color: :pure_white,
              variant: :inverted
            },
            slots: [
              """
              <span>Pure White</span>
              """
            ]
          },
          %Variation{
            id: :white,
            attributes: %{
              color: :white,
              variant: :inverted
            },
            slots: [
              """
              <span>White</span>
              """
            ]
          },
          %Variation{
            id: :light,
            attributes: %{
              color: :light,
              variant: :inverted
            },
            slots: [
              """
              <span>Light</span>
              """
            ]
          },
          %Variation{
            id: :dark,
            attributes: %{
              color: :dark,
              variant: :inverted
            },
            slots: [
              """
              <span>Dark</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :shadow,
        description: "Shadow",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: :primary,
              variant: :shadow
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
              color: :secondary,
              variant: :shadow
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
              color: :info,
              variant: :shadow
            },
            slots: [
              """
              <span>Information</span>
              """
            ]
          },
          %Variation{
            id: :success,
            attributes: %{
              color: :success,
              variant: :shadow
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
              color: :warning,
              variant: :shadow
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
              color: :danger,
              variant: :shadow
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
              color: :gray,
              variant: :shadow
            },
            slots: [
              """
              <span>Gray</span>
              """
            ]
          },
          %Variation{
            id: :pure_white,
            attributes: %{
              color: :pure_white,
              variant: :shadow
            },
            slots: [
              """
              <span>Pure White</span>
              """
            ]
          },
          %Variation{
            id: :white,
            attributes: %{
              color: :white,
              variant: :shadow
            },
            slots: [
              """
              <span>White</span>
              """
            ]
          },
          %Variation{
            id: :light,
            attributes: %{
              color: :light,
              variant: :shadow
            },
            slots: [
              """
              <span>Light</span>
              """
            ]
          },
          %Variation{
            id: :dark,
            attributes: %{
              color: :dark,
              variant: :shadow
            },
            slots: [
              """
              <span>Dark</span>
              """
            ]
          }
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
              <span>xs</span>
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
              <span>sm</span>
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
              <span>md</span>
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
              <span>lg</span>
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
              <span>xl</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :disabled,
        description: "Disabled",
        variations: [
          %Variation{
            id: :disabled_xs,
            attributes: %{
              size: :xs,
              disabled: true
            },
            slots: [
              """
              <span>Disabled xs</span>
              """
            ]
          },
          %Variation{
            id: :disabled_sm,
            attributes: %{
              size: :sm,
              disabled: true
            },
            slots: [
              """
              <span>Disabled sm</span>
              """
            ]
          },
          %Variation{
            id: :disabled_md,
            attributes: %{
              size: :md,
              disabled: true
            },
            slots: [
              """
              <span>Disabled md</span>
              """
            ]
          },
          %Variation{
            id: :disabled_lg,
            attributes: %{
              size: :lg,
              disabled: true
            },
            slots: [
              """
              <span>Disabled lg</span>
              """
            ]
          },
          %Variation{
            id: :disabled_xl,
            attributes: %{
              size: :xl,
              disabled: true
            },
            slots: [
              """
              <span>Disabled xl</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :icon,
        description: "Icon",
        variations: [
          %Variation{
            id: :xs,
            attributes: %{
              icon: "hero-cake",
              size: :xs
            },
            slots: [
              """
              <span>xs</span>
              """
            ]
          },
          %Variation{
            id: :sm,
            attributes: %{
              icon: "hero-cake",
              size: :sm
            },
            slots: [
              """
              <span>sm</span>
              """
            ]
          },
          %Variation{
            id: :md,
            attributes: %{
              icon: "hero-cake",
              size: :md
            },
            slots: [
              """
              <span>md</span>
              """
            ]
          },
          %Variation{
            id: :lg,
            attributes: %{
              icon: "hero-cake",
              size: :lg
            },
            slots: [
              """
              <span>lg</span>
              """
            ]
          },
          %Variation{
            id: :xl,
            attributes: %{
              icon: "hero-cake",
              size: :xl
            },
            slots: [
              """
              <span>xl</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :icon_position,
        description: "Icon positioning",
        variations: [
          %Variation{
            id: :icon_left,
            attributes: %{
              size: :md,
              icon: "hero-trophy",
              icon_position: :left
            },
            slots: [
              """
              <span>Left</span>
              """
            ]
          },
          %Variation{
            id: :icon_right,
            attributes: %{
              size: :md,
              icon: "hero-trophy",
              icon_position: :right
            },
            slots: [
              """
              <span>Right</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :icon_variant,
        description: "Icon variant",
        variations: [
          %Variation{
            id: :mini,
            attributes: %{
              size: :md,
              icon: "hero-radio-mini"
            },
            slots: [
              """
              <span>Mini</span>
              """
            ]
          },
          %Variation{
            id: :solid,
            attributes: %{
              size: :md,
              icon: "hero-radio-solid"
            },
            slots: [
              """
              <span>Solid</span>
              """
            ]
          },
          %Variation{
            id: :outline,
            attributes: %{
              size: :md,
              icon: "hero-radio"
            },
            slots: [
              """
              <span>Outline</span>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :spinner,
        description: "Spinner",
        variations: [
          %Variation{
            id: :xs,
            attributes: %{
              size: :xs,
              spinner: true
            },
            slots: [
              """
              <span>xs</span>
              """
            ]
          },
          %Variation{
            id: :sm,
            attributes: %{
              size: :sm,
              spinner: true
            },
            slots: [
              """
              <span>sm</span>
              """
            ]
          },
          %Variation{
            id: :md,
            attributes: %{
              size: :md,
              spinner: true
            },
            slots: [
              """
              <span>md</span>
              """
            ]
          },
          %Variation{
            id: :lg,
            attributes: %{
              size: :lg,
              spinner: true
            },
            slots: [
              """
              <span>lg</span>
              """
            ]
          },
          %Variation{
            id: :xl,
            attributes: %{
              size: :xl,
              spinner: true
            },
            slots: [
              """
              <span>xl</span>
              """
            ]
          }
        ]
      },
      %Variation{
        id: :full_width,
        attributes: %{
          size: :md,
          full_width: true
        },
        slots: [
          """
          <span>Full width</span>
          """
        ]
      }
    ]
  end
end
