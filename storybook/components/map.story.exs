defmodule AtomicWeb.Storybook.Components.Map do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Map

  def function, do: &Map.map/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          location: "Centro de Estudantes de Engenharia Informática"
        }
      },
      %VariationGroup{
        id: :type,
        description: "Type",
        variations: [
          %Variation{
            id: :normal,
            attributes: %{
              location: "Universidade do Minho - Campus de Gualtar",
              type: :normal
            }
          },
          %Variation{
            id: :satellite,
            attributes: %{
              location: "Universidade do Minho - Campus de Gualtar",
              type: :satellite
            }
          }
        ]
      },
      %Variation{
        id: :zoom,
        attributes: %{
          location: "Núcleo de Informática da AEFEUP",
          zoom: 7
        }
      },
      %Variation{
        id: :controls,
        attributes: %{
          location: "Braga, Portugal",
          controls: true
        }
      }
    ]
  end
end
