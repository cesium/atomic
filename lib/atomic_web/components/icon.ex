defmodule AtomicWeb.Components.Icon do
  @moduledoc """
  A component for rendering icons.

  An icon can either be from the Heroicons or Tabler Icons set.
  """
  use Phoenix.Component

  attr :name, :atom, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
