defmodule AtomicWeb.Storybook.Components.Badges do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Badge

  def function, do: &Badge.badge/1

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
        id: :colors,
        description: "Colors",
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
      },
      %VariationGroup{
        id: :dark,
        description: "Dark",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              color: :primary,
              variant: :dark
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
              variant: :dark
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
              variant: :dark
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
              variant: :dark
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
              variant: :dark
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
              variant: :dark
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
              variant: :dark
            },
            slots: [
              """
              <span>Gray</span>
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
      }
    ]
  end
end
