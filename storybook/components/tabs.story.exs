defmodule AtomicWeb.Storybook.Components.Tabs do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Icon
  alias AtomicWeb.Components.Tabs

  def function, do: &Tabs.tabs/1

  def imports, do: [{Tabs, tab: 1}, {Icon, icon: 1}]

  def variations do
    [
      %Variation{
        id: :simple,
        slots: [
          """
          <.tab active={true}>
            All
          </.tab>
          <.tab>
            Following
          </.tab>
          """
        ]
      },
      %Variation{
        id: :with_numbers,
        slots: [
          """
          <.tab active={true} number={5}>
            All
          </.tab>
          <.tab number={2}>
            Following
          </.tab>
          """
        ]
      },
      %Variation{
        id: :disabled,
        slots: [
          """
          <.tab active={true}>
            All
          </.tab>
          <.tab disabled={true}>
            Following
          </.tab>
          """
        ]
      },
      %Variation{
        id: :custom_class,
        slots: [
          """
          <.tab active={true} class="bg-red-100 text-red-600">
            All
          </.tab>
          <.tab class="bg-blue-100 text-blue-600">
            Following
          </.tab>
          """
        ]
      },
      %Variation{
        id: :with_icon,
        slots: [
          """
          <.tab active={true}>
            <.icon name={:home} class="h-5 w-5 mr-2" />
            All
          </.tab>
          <.tab>
            <.icon name={:star} class="h-5 w-5 mr-2" />
            Following
          </.tab>
          """
        ]
      }
    ]
  end
end
