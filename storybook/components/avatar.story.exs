defmodule AtomicWeb.Storybook.Components.Avatar do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Avatar

  def function, do: &Avatar.avatar/1

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
        attributes: %{
          name: "John Doe"
        }
      },
      %VariationGroup{
        id: :colors,
        description: "Different colors",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{
              name: "João Lobo",
              color: :primary
            }
          },
          %Variation{
            id: :secondary,
            attributes: %{
              name: "João Lobo",
              color: :secondary
            }
          },
          %Variation{
            id: :info,
            attributes: %{
              name: "João Lobo",
              color: :info
            }
          },
          %Variation{
            id: :success,
            attributes: %{
              name: "João Lobo",
              color: :success
            }
          },
          %Variation{
            id: :warning,
            attributes: %{
              name: "João Lobo",
              color: :warning
            }
          },
          %Variation{
            id: :danger,
            attributes: %{
              name: "João Lobo",
              color: :danger
            }
          },
          %Variation{
            id: :gray,
            attributes: %{
              name: "João Lobo",
              color: :gray
            }
          },
          %Variation{
            id: :light_gray,
            attributes: %{
              name: "João Lobo",
              color: :light_gray
            }
          },
          %Variation{
            id: :pure_white,
            attributes: %{
              name: "João Lobo",
              color: :pure_white
            }
          },
          %Variation{
            id: :white,
            attributes: %{
              name: "João Lobo",
              color: :white
            }
          },
          %Variation{
            id: :light,
            attributes: %{
              name: "João Lobo",
              color: :light
            }
          },
          %Variation{
            id: :dark,
            attributes: %{
              name: "João Lobo",
              color: :dark
            }
          }
        ]
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
        id: :image,
        description: "Image",
        variations: [
          %Variation{
            id: :organization,
            attributes: %{
              name: "CeSIUM",
              type: :organization,
              src: "/images/cesium-ORANGE.svg"
            }
          },
          %Variation{
            id: :user,
            attributes: %{
              name: "John Doe",
              type: :user,
              src:
                "https://randomuser.me/api/portraits/#{Enum.random(["men", "women"])}/#{:rand.uniform(50)}.jpg"
            }
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
      }
    ]
  end
end
