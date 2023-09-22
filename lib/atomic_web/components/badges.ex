defmodule AtomicWeb.Components.Badges do
  @moduledoc false
  use AtomicWeb, :component

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)

  def badge_dot(assigns) do
    assigns =
      assigns
      |> assign_new(:color, fn -> "gray" end)
      |> assign_new(:url, fn -> "#" end)

    background =
      case assigns.color do
        "gray" ->
          "bg-gray-900"

        "red" ->
          "bg-red-600"

        "purple" ->
          "bg-purple-600"
      end

    assigns = assign(assigns, :background, background)

    ~H"""
    <%= live_redirect to: @url, class: "relative inline-flex items-center rounded-full border border-gray-300 px-3 py-0.5" do %>
      <div class="absolute flex flex-shrink-0 items-center justify-center">
        <span class={"#{@background} h-1.5 w-1.5 rounded-full"} aria-hidden="true"></span>
      </div>
      <div class="ml-3.5 text-sm font-medium text-gray-900">
        <%= render_slot(@inner_block) %>
      </div>
    <% end %>
    """
  end

  def badge(assigns) do
    assigns = assign(assigns, :color, fn -> :gray end)

    ~H"""
    <span class={"#{get_color_classes(@color)} inline-flex items-center rounded-full px-3 py-0.5 text-sm font-semibold"}>
      <%= @text %>
    </span>
    """
  end

  defp get_color_classes(nil), do: "bg-neutral-100 text-neutral-800"

  defp get_color_classes(color) when is_atom(color) do
    color
    |> Atom.to_string()
    |> get_color_classes()
  end

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp get_color_classes(color) when color in @colors do
    "bg-#{color}-100 text-#{color}-800"
  end
end
