defmodule AtomicWeb.Storybook.Components.Avatar do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Avatar

  def function, do: &Avatar.avatar/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          name: "John Doe"
        }
      },
      %Variation{
        id: :user,
        attributes: %{
          name: "Rui Lopes",
          type: :user
        }
      },
      %Variation{
        id: :organization,
        attributes: %{
          name: "CeSIUM",
          type: :organization
        }
      },
      %Variation{
        id: :company,
        attributes: %{
          name: "Acme Inc.",
          type: :company
        }
      },
      %VariationGroup{
        id: :sizes,
        description: "Different sizes",
        variations: [
          %Variation{
            id: :extra_small,
            attributes: %{
              name: "John Doe",
              type: :user,
              size: :xs
            }
          },
          %Variation{
            id: :small,
            attributes: %{
              name: "John Doe",
              type: :user,
              size: :sm
            }
          },
          %Variation{
            id: :medium,
            attributes: %{
              name: "John Doe",
              type: :user,
              size: :md
            }
          },
          %Variation{
            id: :large,
            attributes: %{
              name: "John Doe",
              type: :user,
              size: :lg
            }
          },
          %Variation{
            id: :extra_large,
            attributes: %{
              name: "John Doe",
              type: :user,
              size: :xl
            }
          }
        ]
      },
      %Variation{
        id: :custom_fg_color,
        description: "Custom foreground color",
        attributes: %{
          name: "John Doe",
          type: :user,
          fg_color: "black"
        }
      },
      %Variation{
        id: :custom_bg_color,
        description: "Custom background color",
        attributes: %{
          name: "John Doe",
          type: :user,
          bg_color: "black"
        }
      }
    ]
  end
end
