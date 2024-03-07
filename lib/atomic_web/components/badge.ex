defmodule AtomicWeb.Components.Badge do
  @moduledoc false
  use AtomicWeb, :component

  attr :bg_color, :string, default: "gray-100"
  attr :fg_color, :string, default: "gray-100"
  attr :variable, :atom, values: [:dot, :normal], default: :normal
  slot :inner_block, required: true

  def badge(assigns) do
    background = "bg-#{assigns.bg_color}"

    assigns = assign(assigns, :background, background)

    ~H"""
    <%!-- <div class="relative inline-flex items-center rounded-full border border-gray-300 px-3 py-0.5"> --%>
    <div class={generate_classes(assigns)}>
      <%= if @variable == :dot do %>
        <div class="flex flex-shrink-0 items-center justify-center">
          <span class={"#{@background} mr-2 h-1.5 w-1.5 rounded-full"} aria-hidden="true"></span>
        </div>
      <% end %>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp generate_classes(assigns) do
    "#{classes(:bg_color, assigns)} #{classes(:variable, assigns)}"
  end

  defp classes(:bg_color, %{bg_color: color, variable: :normal}), do: "bg-#{color}"

  defp classes(:variable, %{variable: :normal}),
    do:
      "ml-auto select-none self-center rounded-xl border border-green-300 px-3 py-2 text-green-400"

  defp classes(:variable, %{variable: :dot}),
    do:
      "relative inline-flex items-center rounded-full border border-gray-300 px-3 py-0.5 text-sm font-medium text-gray-900"

  defp classes(_, _), do: ""
end
