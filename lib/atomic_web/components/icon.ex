defmodule AtomicWeb.Components.Icon do
  @moduledoc """
  A component for rendering an icon from the Heroicons package.
  """
  use Phoenix.Component

  attr :rest, :global,
    doc: "The arbitrary HTML attributes for the svg container",
    include: ~w(fill stroke stroke-width)

  attr :name, :atom, required: true
  attr :outline, :boolean, default: true
  attr :solid, :boolean, default: false
  attr :mini, :boolean, default: false

  def render(assigns) do
    apply(Heroicons, assigns.name, [assigns])
  end
end
