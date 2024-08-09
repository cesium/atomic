defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use Phoenix.Component

  import AtomicWeb.Components.Icon
  import AtomicWeb.Components.Spinner

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :sm,
    doc: "The size of the button."

  attr :variant, :atom,
    default: :solid,
    values: [:solid, :outline, :inverted, :shadow],
    doc: "The variant of the button."

  attr :color, :atom,
    default: :primary,
    values: [
      :primary,
      :secondary,
      :info,
      :success,
      :warning,
      :danger,
      :gray,
      :pure_white,
      :white,
      :light,
      :dark
    ],
    doc: "Button color."

  attr :disabled, :boolean, default: false, doc: "Indicates a disabled state."

  attr :full_width, :boolean,
    default: false,
    doc: "If true, the component will take up the full width of its container."

  attr :spinner, :boolean, default: false, doc: "If true, the button will display a spinner."

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

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  attr :rest, :global,
    include:
      ~w(csrf_token download form href hreflang method name navigate patch referrerpolicy rel replace target type value autofocus tabindex),
    doc: "Arbitrary HTML or phx attributes."

  slot :inner_block, required: false, doc: "Slot for the content of the button."

  def button(assigns) do
    assigns
    |> assign(:class, generate_classes(assigns))
    |> render_button()
  end

  defp render_button(%{rest: %{href: _}} = assigns) do
    link_button(assigns)
  end

  defp render_button(%{rest: %{navigate: _}} = assigns) do
    link_button(assigns)
  end

  defp render_button(%{rest: %{patch: _}} = assigns) do
    link_button(assigns)
  end

  defp render_button(assigns) do
    ~H"""
    <button class={@class} disabled={@disabled} {@rest}>
      <%= render_content(assigns) %>
    </button>
    """
  end

  defp link_button(assigns) do
    ~H"""
    <.link class={@class} {@rest}>
      <%= render_content(assigns) %>
    </.link>
    """
  end

  defp render_content(assigns) do
    ~H"""
    <%= if (@icon || @spinner) && @icon_position == :left do %>
      <div>
        <%= if @icon do %>
          <%= icon_content(assigns) %>
        <% end %>
        <%= if @spinner do %>
          <%= spinner_content(assigns) %>
        <% end %>
      </div>
    <% end %>
    <%= if Map.has_key?(assigns, :inner_block) do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    <%= if (@icon || @spinner) && @icon_position == :right do %>
      <div>
        <%= if @icon do %>
          <%= icon_content(assigns) %>
        <% end %>
        <%= if @spinner do %>
          <%= spinner_content(assigns) %>
        <% end %>
      </div>
    <% end %>
    """
  end

  defp icon_content(assigns) do
    ~H"""
    <.icon name={@icon} class={"#{generate_icon_classes(assigns)}"} solid={@icon_variant == :solid} mini={@icon_variant == :mini} />
    """
  end

  defp spinner_content(assigns) do
    ~H"""
    <.spinner size_class={"#{generate_icon_classes(assigns)}"} size={@size} />
    """
  end

  defp generate_classes(assigns) do
    [
      "atomic-button",
      "atomic-button--#{assigns.color}#{if assigns.variant == :solid, do: "", else: "-#{assigns.variant}"}",
      "atomic-button--#{assigns.size}",
      assigns.class,
      assigns.spinner && "atomic-button--spinner",
      assigns.disabled && "atomic-button--disabled",
      assigns.icon && "atomic-button--with-icon",
      assigns.full_width && "atomic-button--full-width"
    ]
  end

  defp generate_icon_classes(assigns) do
    [
      "atomic-button__icon--#{assigns.size}",
      assigns.icon_class
    ]
  end
end
