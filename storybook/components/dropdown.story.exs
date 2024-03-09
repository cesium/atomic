defmodule AtomicWeb.Storybook.Components.Dropdown do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Dropdown

  def function, do: &Dropdown.dropdown/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          label: "Dropdown",
          type: :button,
          items: [
            %{name: "Profile", link: "#"},
            %{name: "Settings", link: "#"},
            %{name: "Logout", link: "#"}
          ]
        }
      },
      %Variation{
        id: :avatar,
        attributes: %{
          label: "Dropdown",
          type: :avatar,
          items: [
            %{name: "Profile", link: "#"},
            %{name: "Settings", link: "#"},
            %{name: "Logout", link: "#"}
          ]
        }
      }
    ]
  end
end
