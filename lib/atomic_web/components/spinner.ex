defmodule AtomicWeb.Components.Spinner do
  @moduledoc false
  use Phoenix.Component

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :sm,
    doc: "The size of the spinner."

  attr :show, :boolean, default: true, doc: "Show or hide spinner."

  attr :size_class, :string, default: nil, doc: "Custom CSS classes for size. eg: h-4 w-4"

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  attr :rest, :global

  def spinner(assigns) do
    ~H"""
    <svg {@rest} class={generate_classes(assigns)} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
    </svg>
    """
  end

  defp generate_classes(assigns) do
    size_classes = assigns.size_class || "atomic-spinner--#{assigns.size}"

    [
      "atomic-spinner #{assigns.class}",
      !assigns.show && "hidden",
      size_classes
    ]
  end
end
