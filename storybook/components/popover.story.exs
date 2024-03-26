defmodule AtomicWeb.Storybook.Components.Popover do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Popover


  def function, do: &Popover.popover/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          type: :button,
          position: :bottom,
          button: %{
            name: "Button",
            description: "This is a button."
          }
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
        id: :Positon,
        description: "Position",
        variations: [
          %Variation{
            id: :bottom,
            attributes: %{
              type: :button,
              position: :bottom,
              button: %{
                name: "Button",
                description: "The popover is positioned at the bottom."
              }
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Bottom</button>
              </:wrapper>
              """
            ]
          },
          %Variation{
            id: :top,
            attributes: %{
              type: :button,
              position: :top,
              button: %{
                name: "Button",
                description: "The popover is positioned at the top."
              }
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Top</button>
              </:wrapper>
              """
            ]
          },
          %Variation{
            id: :right,
            attributes: %{
              type: :button,
              position: :right,
              button: %{
                name: "Button",
                description: "The popover is positioned at the right."
              }
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Right</button>
              </:wrapper>
              """
            ]
          },
          %Variation{
            id: :left,
            attributes: %{
              type: :button,
              position: :left,
              button: %{
                name: "Button",
                description: "The popover is positioned at the left."
              }
            },
            slots: [
              """
              <:wrapper>
                <button class="bg-blue-500 text-white px-4 py-2 rounded-md">Button Left</button>
              </:wrapper>
              """
            ]
          }
        ],
      }
    ]
  end

end
