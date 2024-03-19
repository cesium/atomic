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
          <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button</button>
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
              <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Down</button>
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
              <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Top</button>
              """
            ]
          }
        ]
      }
    ]
  end
end
