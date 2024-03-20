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
            %{name: "Profile", link: "#"},
            %{name: "Settings", link: "#"},
            %{name: "Logout", link: "#"}
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
                %{name: "Profile", link: "#"},
                %{name: "Settings", link: "#"},
                %{name: "Logout", link: "#"}
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
                %{name: "Profile", link: "#"},
                %{name: "Settings", link: "#"},
                %{name: "Logout", link: "#"}
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
              icon_variant: :solid,
              items: [
                %{name: "Profile", link: "#", icon: :user},
                %{name: "Settings", link: "#", icon: :cog},
                %{name: "Logout", link: "#", icon: :arrow_left_on_rectangle}
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
              icon_variant: :outline,
              items: [
                %{name: "Profile", link: "#", icon: :user},
                %{name: "Settings", link: "#", icon: :cog},
                %{name: "Logout", link: "#", icon: :arrow_left_on_rectangle}
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
