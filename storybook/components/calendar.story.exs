defmodule AtomicWeb.Storybook.Components.Calendar do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Calendar

  def function, do: &Calendar.calendar/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          current_path: "/storybook/components/calendar",
          activities: [],
          mode: "month",
          timezone: "Europe/Lisbon",
          params: %{}
        }
      },
      %Variation{
        id: :weekly,
        attributes: %{
          current_path: "/storybook/components/calendar",
          activities: [],
          mode: "week",
          timezone: "Europe/Lisbon",
          params: %{}
        }
      }
    ]
  end
end
