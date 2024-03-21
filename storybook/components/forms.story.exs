defmodule AtomicWeb.Storybook.Components.Forms do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Forms

  def function, do: &Forms.field/1

  def template do
    """
    <.form id="form" :let={form} for={%{name: "Text"}}>
      <.lsb-variation field={form[:name]}/>
    </.form>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          type: "text",
          placeholder: "Text"
        }
      }
    ]
  end
end
