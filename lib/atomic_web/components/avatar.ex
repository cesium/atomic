defmodule AtomicWeb.Components.Avatar do
  @moduledoc false
  use AtomicWeb, :component

  attr :src, :string, default: nil, doc: "The URL of the image to display."

  attr :name, :string, required: true, doc: "The name of the entity associated with the avatar."

  attr :auto_generate_initials, :boolean,
    default: true,
    doc: "Whether to automatically generate the initials from the name."

  attr :type, :atom,
    values: [:user, :organization, :company],
    default: :user,
    doc: "The type of entity associated with the avatar."

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :md,
    doc: "The size of the avatar."

  attr :fg_color, :string,
    default: "white",
    doc: "The color of the text when no image is provided."

  attr :bg_color, :string,
    default: "zinc-400",
    doc: "The background color of the avatar when no image is provided."

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  def avatar(assigns) do
    ~H"""
    <span class={generate_classes(assigns)}>
      <%= if @src do %>
        <img src={@src} class="h-full w-full" />
      <% else %>
        <%= if @auto_generate_initials do %>
          <%= extract_initials(@name) %>
        <% else %>
          <%= @name %>
        <% end %>
      <% end %>
    </span>
    """
  end

  defp generate_classes(assigns) do
    "flex shrink-0 items-center justify-center select-none #{classes(:type, assigns)} #{classes(:size, assigns)} #{classes(:bg_color, assigns)} #{classes(:fg_color, assigns)} #{assigns.class}"
  end

  defp classes(:type, %{type: :user}), do: "rounded-full"

  defp classes(:type, %{type: :organization}), do: "rounded-lg"

  defp classes(:type, %{type: :company}), do: "rounded-lg"

  defp classes(:size, %{size: :xs}), do: "h-8 w-8 text-xs font-medium leading-none"

  defp classes(:size, %{size: :sm}), do: "h-12 w-12 text-lg font-medium leading-none"

  defp classes(:size, %{size: :md}), do: "h-16 w-16 text-lg font-medium leading-none"

  defp classes(:size, %{size: :lg}), do: "h-20 w-20 text-4xl font-medium leading-none"

  defp classes(:size, %{size: :xl}), do: "h-24 w-24 text-4xl font-medium leading-none"

  defp classes(:fg_color, %{fg_color: color}), do: "text-#{color}"

  defp classes(:bg_color, %{bg_color: color, src: nil}), do: "bg-#{color}"

  defp classes(_, _), do: ""
end
