defmodule AtomicWeb.Storybook.Components.Forms do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Forms

  def function, do: &Forms.field/1

  def template do
    """
    <.form for={nil}>
      <.lsb-variation-group />
    </.form>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          field: nil,
          placeholder: "Choose a title"
        }
      }
    ]
  end
end
