defmodule AtomicWeb.Components.Badge do
  @moduledoc false
  use Phoenix.Component

  import AtomicWeb.Components.Icon

  attr :size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"]
  attr :variant, :string, default: "light", values: ["light", "dark", "outline"]

  attr :color, :string,
    default: "primary",
    values: ["primary", "secondary", "info", "success", "warning", "danger", "gray"]

  attr :icon_position, :atom,
    values: [:left, :right],
    default: :left,
    doc: "The position of the icon if applicable."

  attr :icon, :atom, default: nil, doc: "The icon to display."

  attr :icon_variant, :atom,
    default: :outline,
    values: [:solid, :outline, :mini],
    doc: "The icon variation to display."

  attr :icon_class, :string, default: "", doc: "Additional classes to apply to the icon."

  attr :with_icon, :boolean, default: false, doc: "adds some icon base classes"
  attr :class, :string, default: "", doc: "CSS class for parent div"
  attr :label, :string, default: nil, doc: "label your badge"
  attr :rest, :global
  slot :inner_block, required: false

  def badge(assigns) do
    ~H"""
    <div
      {@rest}
      class={[
        "atomic-badge",
        "atomic-badge--#{@size}",
        "atomic-badge--#{@color}-#{@variant}",
        @class
      ]}
    >
      <%= if @icon && @icon_position == :left do %>
        <.icon name={@icon} class={"#{generate_icon_classes(assigns)}"} solid={@icon_variant == :solid} mini={@icon_variant == :mini} />
      <% end %>
      <%= render_slot(@inner_block) || @label %>
      <%= if @icon && @icon_position == :right do %>
        <.icon name={@icon} class={"#{generate_icon_classes(assigns)}"} solid={@icon_variant == :solid} mini={@icon_variant == :mini} />
      <% end %>
    </div>
    """
  end

  defp generate_icon_classes(assigns) do
    [
      "atomic-button__icon--#{assigns.size}",
      assigns.icon_class
    ]
  end
end
