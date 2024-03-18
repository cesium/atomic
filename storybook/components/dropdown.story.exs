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
