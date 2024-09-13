defmodule AtomicWeb.Storybook.Components.Dropdown do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Dropdown

  def function, do: &Dropdown.dropdown/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          id: "dropdown",
          items: [
            %{name: "Profile", navigate: "#"},
            %{name: "Settings", navigate: "#"},
            %{name: "Logout", navigate: "#"}
          ],
          orientation: :down
        },
        slots: [
          """
          <:wrapper>
          <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button</button>
          </:wrapper>
          """
        ]
      },
      %VariationGroup{
        id: :orientation,
        description: "Orientation",
        variations: [
          %Variation{
            id: :button,
            attributes: %{
              id: "dropdown-down",
              items: [
                %{name: "Profile", navigate: "#"},
                %{name: "Settings", navigate: "#"},
                %{name: "Logout", navigate: "#"}
              ],
              orientation: :down
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Down</button>
              </:wrapper>
              """
            ]
          },
          %Variation{
            id: :top,
            attributes: %{
              id: "dropdown-top",
              items: [
                %{name: "Profile", navigate: "#"},
                %{name: "Settings", navigate: "#"},
                %{name: "Logout", navigate: "#"}
              ],
              orientation: :top
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Top</button>
              </:wrapper>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :icons,
        description: "Icons",
        variations: [
          %Variation{
            id: :button,
            attributes: %{
              id: "dropdown-solid-icons",
              items: [
                %{name: "Profile", navigate: "#", icon: "hero-users-solid"},
                %{name: "Settings", navigate: "#", icon: "hero-cog-solid"},
                %{name: "Logout", navigate: "#", icon: "hero-arrow-left-on-rectangle-solid"}
              ],
              orientation: :down
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Dropdown with Solid Icons</button>
              </:wrapper>
              """
            ]
          },
          %Variation{
            id: :top,
            attributes: %{
              id: "dropdown-outline-icons",
              items: [
                %{name: "Profile", navigate: "#", icon: "hero-user"},
                %{name: "Settings", navigate: "#", icon: "hero-cog"},
                %{name: "Logout", navigate: "#", icon: "hero-arrow-left-on-rectangle"}
              ],
              orientation: :top
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Dropdown with Outline Icons</button>
              </:wrapper>
              """
            ]
          }
        ]
      }
    ]
  end
end
