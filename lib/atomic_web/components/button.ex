defmodule AtomicWeb.Components.Button do
  @moduledoc false
  use Phoenix.Component

  import AtomicWeb.Components.Icon
  import AtomicWeb.Components.Spinner

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
    doc: "Arbitrary HTML or phx attributes.",
    include:
      ~w(csrf_token disabled download form href hreflang method name navigate patch referrerpolicy rel replace target type value)
  )

  attr :spinner, :boolean, default: false, doc: "If true, the button will display a spinner."

  attr :icon_position, :atom,
    values: [:left, :right],
    default: :left,
    doc: "The position of the icon if applicable."

  attr :icon, :atom, default: nil, doc: "The icon to display."

  attr :icon_class, :string, default: "h-6 w-6", doc: "Additional classes to apply to the icon."

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  slot :inner_block, required: true, doc: "Slot for the body content of the page."

  def button(assigns) do
    assigns
    |> assign(:class, generate_classes(assigns))
    |> render_button()
  end

  defp render_button(%{spinner: true} = assigns) do
    ~H"""
    <button class={@class} {@rest} disabled>
      <.spinner class="mx-4" />
    </button>
    """
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

  defp link_button(assigns) do
    ~H"""
    <.link class={@class} {@rest}>
      <%= render_content(assigns) %>
    </.link>
    """
  end

  defp render_button(assigns) do
    ~H"""
    <button class={@class} {@rest}>
      <%= render_content(assigns) %>
    </button>
    """
  end

  defp render_content(assigns) do
    ~H"""
    <%= if @icon && @icon_position == :left do %>
      <div>
        <.icon name={@icon} class={"#{@icon_class} mr-2"} />
      </div>
    <% end %>
    <%= render_slot(@inner_block) %>
    <%= if @icon && @icon_position == :right do %>
      <div>
        <.icon name={@icon} class={"#{@icon_class} ml-2"} />
      </div>
    <% end %>
    """
  end

  defp generate_classes(assigns) do
    "text-center justify-center inline-flex items-center rounded-md shadow-sm #{classes(:full_width, assigns)} #{classes(:fg_color, assigns)} #{classes(:size, assigns)} #{classes(:bg_color, assigns)} #{classes(:bg_color_hover, assigns)} #{assigns.class}"
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
