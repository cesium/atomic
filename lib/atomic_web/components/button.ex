defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use AtomicWeb, :component

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :sm,
    doc: "The size of the button."

  attr :fg_color, :string, default: "white", doc: "The color of the text and icon if applicable."

  attr :bg_color, :string, default: "orange-500", doc: "The background color of the button."

  attr :bg_color_hover, :string,
    default: "orange-600",
    doc: "The background color of the button on hover."

  attr(:full_width, :boolean,
    doc: "If true, the component will take up the full width of its container."
  )

  attr(:rest, :global,
    doc: "Arbitrary HTML or phx attributes",
    include:
      ~w(csrf_token disabled download form href hreflang method name navigate patch referrerpolicy rel replace target type value)
  )

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  slot(:inner_block, required: true)

  def button(assigns) do
    assigns
    |> assign(:class, generate_classes(assigns))
    |> render_button()
  end

  defp render_button(%{rest: %{href: _}} = assigns) do
    ~H"""
    <.link class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp render_button(%{rest: %{navigate: _}} = assigns) do
    ~H"""
    <.link class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp render_button(%{rest: %{patch: _}} = assigns) do
    ~H"""
    <.link class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp render_button(assigns) do
    ~H"""
    <button class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp generate_classes(assigns) do
    "text-center inline-flex items-center rounded-md shadow-sm #{classes(:full_width, assigns)} #{classes(:fg_color, assigns)} #{classes(:size, assigns)} #{classes(:bg_color, assigns)} #{classes(:bg_color_hover, assigns)} #{assigns.class}"
  end

  defp classes(:fg_color, %{fg_color: color}), do: "text-#{color}"

  defp classes(:bg_color, %{bg_color: color}), do: "bg-#{color}"

  defp classes(:bg_color_hover, %{bg_color_hover: color}), do: "hover:bg-#{color}"

  defp classes(:size, %{size: :xs}), do: "py-1 px-1.5 text-xs"

  defp classes(:size, %{size: :sm}), do: "py-2 px-3 text-sm"

  defp classes(:size, %{size: :md}), do: "py-2 px-4 text-base font-semibold"

  defp classes(:size, %{size: :lg}), do: "py-3 px-5 text-xl font-bold"

  defp classes(:full_width, %{full_width: true}), do: "w-full"

  defp classes(_, _), do: ""
end
