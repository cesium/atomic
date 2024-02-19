defmodule AtomicWeb.Components.Avatar do
  @moduledoc false
  use AtomicWeb, :component

  attr :src, :string, required: true
  attr :name, :string, required: true
  attr :type, :atom, values: [:user, :company], default: :user
  attr :size, :atom, values: [:xs, :sm, :md, :lg, :xl], default: :md
  attr :color, :string, default: "zinc-500"
  attr :class, :string, default: ""

  def avatar(assigns) do
    ~H"""
    <span class={generate_classes(assigns)}>
      <%= if @src do %>
        <img src={@src} class="h-full w-full" />
      <% else %>
        <%= extract_initials(@name) %>
      <% end %>
    </span>
    """
  end

  defp generate_classes(assigns) do
    "flex shrink-0 items-center justify-center #{classes(:type, assigns)} #{classes(:size, assigns)} #{classes(:color, assigns)} #{assigns.class}"
  end

  defp classes(:type, %{type: :user}), do: "rounded-xl"

  defp classes(:type, %{type: :company}), do: "rounded-lg"

  defp classes(:size, %{size: :xs}), do: "h-8 w-8"

  defp classes(:size, %{size: :sm}), do: "h-12 w-12 text-lg font-medium leading-none"

  defp classes(:size, %{size: :md}), do: "h-16 w-16"

  defp classes(:size, %{size: :lg}), do: "h-20 w-20"

  defp classes(:size, %{size: :xl}), do: "h-24 w-24 text-4xl font-medium leading-none"

  defp classes(:color, %{color: color}), do: "bg-#{color}"
end
