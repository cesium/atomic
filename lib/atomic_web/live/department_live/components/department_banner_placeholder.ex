defmodule AtomicWeb.DepartmentLive.Components.DepartmentBannerPlaceholder do
  @moduledoc false
  use AtomicWeb, :component

  def department_banner_placeholder(assigns) do
    {gradient_color_a, gradient_color_b} = generate_color(assigns.department.id)

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

  def generate_color(uuid) when is_binary(uuid) do
    # List of gradients
    colors = [
      {"#000046", "#1CB5E0"},
      {"#007991", "#78ffd6"},
      {"#30E8BF", "#FF8235"},
      {"#C33764", "#1D2671"},
      {"#34e89e", "#0f3443"},
      {"#44A08D", "#093637"},
      {"#DCE35B", "#45B649"},
      {"#c0c0aa", "#1cefff"}
    ]

    # Convert the UUID to an integer
    index = :erlang.phash2(uuid, length(colors))

    # Return the chosen color
    Enum.at(colors, index)
  end
end
