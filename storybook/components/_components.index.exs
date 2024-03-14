defmodule Storybook.Components do
  use PhoenixStorybook.Index

  def folder_icon, do: {:fa, "toolbox", :light, "lsb-mr-1"}
  def folder_name, do: "Components"
  def folder_open?, do: true
end
