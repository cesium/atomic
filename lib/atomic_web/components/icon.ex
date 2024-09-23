defmodule AtomicWeb.Components.Icon do
  @moduledoc """
  A component for rendering icons.

  An icon can either be from the [Heroicons](https://heroicons.com) or [Tabler Icons](https://tabler.io/icons) set.
  """
  use Phoenix.Component

  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  def icon(%{name: "tabler-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
