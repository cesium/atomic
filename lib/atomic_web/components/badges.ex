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

    ~H"""
    <%= live_redirect to: @url, class: "relative inline-flex items-center rounded-full border border-gray-300 px-3 py-0.5" do %>
      <div class="absolute flex flex-shrink-0 items-center justify-center">
        <span class={"h-1.5 w-1.5 rounded-full #{background}"} aria-hidden="true"></span>
      </div>
      <div class="ml-3.5 text-sm font-medium text-gray-900">
        <%= render_slot(@inner_block) %>
      </div>
    <% end %>
    """
  end

  def badge(assigns) do
    assigns = assign_new(assigns, :color, fn -> :gray end)

    ~H"""
    <span class={"inline-flex items-center px-3 py-0.5 rounded-full text-sm font-semibold #{get_color_classes(@color)}"}>
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
    case color do
      "gray" -> "bg-gray-100 text-gray-800"
      "red" -> "bg-red-100 text-red-800"
      "orange" -> "bg-orange-100 text-orange-800"
      "amber" -> "bg-amber-100 text-amber-800"
      "yellow" -> "bg-yellow-100 text-yellow-800"
      "lime" -> "bg-lime-100 text-lime-800"
      "green" -> "bg-green-100 text-green-800"
      "emerald" -> "bg-emerald-100 text-emerald-800"
      "teal" -> "bg-teal-100 text-teal-800"
      "cyan" -> "bg-cyan-100 text-cyan-800"
      "sky" -> "bg-sky-100 text-sky-800"
      "blue" -> "bg-blue-100 text-blue-800"
      "indigo" -> "bg-indigo-100 text-indigo-800"
      "violet" -> "bg-violet-100 text-violet-800"
      "purple" -> "bg-purple-100 text-purple-800"
      "fuchsia" -> "bg-fuchsia-100 text-fuchsia-800"
      "pink" -> "bg-pink-100 text-pink-800"
      "rose" -> "bg-rose-100 text-rose-800"
    end
  end
end
