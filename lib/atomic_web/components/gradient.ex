defmodule AtomicWeb.Components.Gradient do
  @moduledoc """
  Generates a random gradient background or a predictable gradient background based on a seed that can be of any data type.
  """
  use Phoenix.Component

  # List of gradients
  @colors [
    {"#000046", "#1CB5E0"},
    {"#007991", "#78ffd6"},
    {"#30E8BF", "#FF8235"},
    {"#C33764", "#1D2671"},
    {"#34e89e", "#0f3443"},
    {"#44A08D", "#093637"},
    {"#DCE35B", "#45B649"},
    {"#c0c0aa", "#1cefff"},
    {"#ee0979", "#ff6a00"}
  ]

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."
  attr :seed, :any, required: false, doc: "For predictable gradients."

  def gradient(assigns) do
    {gradient_color_a, gradient_color_b} =
      if Map.has_key?(assigns, :id) do
        generate_color(assigns.id)
      else
        generate_color()
      end

    assigns
    |> assign(:gradient_color_a, gradient_color_a)
    |> assign(:gradient_color_b, gradient_color_b)
    |> render_gradient()
  end

  defp render_gradient(assigns) do
    ~H"""
    <div style={"background: linear-gradient(90deg, #{@gradient_color_a} 0%, #{@gradient_color_b} 100%);"} class={"#{@class} h-full w-full"}></div>
    """
  end

  defp generate_color(seed) when is_binary(seed) do
    # Convert the argument into an integer
    index = :erlang.phash2(seed, length(@colors))

    # Return the chosen color
    Enum.at(@colors, index)
  end

  defp generate_color do
    Enum.random(@colors)
  end
end
