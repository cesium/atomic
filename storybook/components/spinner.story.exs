defmodule AtomicWeb.Storybook.Components.Spinner do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Spinner

  def function, do: &Spinner.spinner/1

  def variations do
    [
      %Variation{
        id: :default
      },
      %VariationGroup{
        id: :sizes,
        description: "Different sizes",
        variations: [
          %Variation{
            id: :extra_small,
            attributes: %{
              size: :xs
            }
          },
          %Variation{
            id: :small,
            attributes: %{
              size: :sm
            }
          },
          %Variation{
            id: :medium,
            attributes: %{
              size: :md
            }
          },
          %Variation{
            id: :large,
            attributes: %{
              size: :lg
            }
          },
          %Variation{
            id: :extra_large,
            attributes: %{
              size: :xl
            }
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        variations: [
          %Variation{
            id: :red,
            attributes: %{
              size: :md,
              class: "text-primary-500"
            }
          },
          %Variation{
            id: :small,
            attributes: %{
              size: :lg,
              class: "text-secondary-500"
            }
          }
        ]
      }
    ]
  end
end
