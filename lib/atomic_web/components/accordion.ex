defmodule AtomicWeb.Components.Accordion do
  @moduledoc """
  Provides accordion-related components and helper functions.
  """
  use AtomicWeb, :component

  alias Phoenix.LiveView.JS
  import AtomicWeb.Components.Icon

  @doc """
  Accordion components allows users to show and hide sections of related panel on a page.

  ## Examples

  ```heex
  <.accordion>
    <:trigger>Accordion</:trigger>
    <:panel>Content</:panel>
  </.accordion>
  ```
  """

  attr :class, :any, doc: "Extend existing component styles"
  attr :controlled, :boolean, default: false
  attr :id, :string, required: true
  attr :rest, :global

  slot :trigger, validate_attrs: false
  slot :panel, validate_attrs: false

  @spec accordion(Socket.assigns()) :: Rendered.t()
  def accordion(assigns) do
    ~H"""
    <div class={["accordion", assigns[:class]]} id={@id} {@rest}>
      <%= for {{trigger, panel}, idx} <- @trigger |> Enum.zip(@panel) |> Enum.with_index() do %>
        <h3>
          <button
            aria-controls={panel_id(@id, idx)}
            aria-expanded={to_string(panel[:default_expanded] == true)}
            class={[
              "accordion-trigger relative w-full [&_.accordion-trigger-icon]:aria-expanded:rotate-180",
              trigger[:class]
            ]}
            id={trigger_id(@id, idx)}
            phx-click={handle_click(assigns, idx)}
            type="button"
            {assigns_to_attributes(trigger, [:class, :icon_name])}
          >
            {render_slot(trigger)}
            <.icon class="accordion-trigger-icon size-5 absolute top-1/2 right-4 -translate-y-1/2 transition-all duration-300 ease-in-out" name={trigger[:icon_name] || "hero-chevron-down"} />
          </button>
        </h3>
        <div class="accordion-panel grid-rows-[0fr] grid transform transition-all duration-200 ease-in data-[expanded]:grid-rows-[1fr]" data-expanded={panel[:default_expanded]} id={panel_id(@id, idx)} role="region">
          <div class="overflow-hidden">
            <div class={["accordion-panel-content", panel[:class]]} {assigns_to_attributes(panel, [:class, :default_expanded ])}>
              {render_slot(panel)}
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp trigger_id(id, idx), do: "#{id}_trigger#{idx}"
  defp panel_id(id, idx), do: "#{id}_panel#{idx}"

  defp handle_click(%{controlled: controlled, id: id}, idx) do
    op =
      {"aria-expanded", "true", "false"}
      |> JS.toggle_attribute(to: "##{trigger_id(id, idx)}")
      |> JS.toggle_attribute({"data-expanded", ""}, to: "##{panel_id(id, idx)}")

    if controlled do
      op
      |> JS.set_attribute({"aria-expanded", "false"},
        to: "##{id} .accordion-trigger:not(##{trigger_id(id, idx)})"
      )
      |> JS.remove_attribute("data-expanded",
        to: "##{id} .accordion-panel:not(##{panel_id(id, idx)})"
      )
    else
      op
    end
  end
end
