defmodule AtomicWeb.Storybook.Components.AvatarGroup do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Avatar

  def function, do: &Avatar.avatar_group/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          items:
            Enum.reduce(1..4, [], fn _, acc ->
              [generate_avatar_props() | acc]
            end)
        }
      },
      %VariationGroup{
        id: :spacing,
        description: "Different spacing",
        variations: [
          %Variation{
            id: :minus_three,
            attributes: %{
              spacing: -3,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :minus_two,
            attributes: %{
              spacing: -2,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :minus_one,
            attributes: %{
              spacing: -1,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :zero,
            attributes: %{
              spacing: 0,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :one,
            attributes: %{
              spacing: 1,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :two,
            attributes: %{
              spacing: 2,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :three,
            attributes: %{
              spacing: 3,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          }
        ]
      },
      %Variation{
        id: :wrap,
        attributes: %{
          wrap: true,
          spacing: 0,
          avatar_class: "gap-2",
          items:
            Enum.reduce(1..32, [], fn _, acc ->
              [generate_avatar_props() | acc]
            end)
        }
      },
      %VariationGroup{
        id: :size,
        description: "Avatar props",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              size: :xs,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :size_small,
            attributes: %{
              size: :sm,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :color_danger,
            attributes: %{
              color: :danger,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :color_info,
            attributes: %{
              color: :info,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :type_organization,
            attributes: %{
              type: :organization,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          },
          %Variation{
            id: :type_company,
            attributes: %{
              type: :company,
              items: [
                %{name: "John Doe"},
                %{name: "Mike Smith"},
                %{name: "Sara Johnson"}
              ]
            }
          }
        ]
      }
    ]
  end

  def generate_avatar_props() do
    %{
      name: Faker.Person.name(),
      src:
        "https://randomuser.me/api/portraits/#{Enum.random(["men", "women"])}/#{:rand.uniform(50)}.jpg"
    }
  end
end
