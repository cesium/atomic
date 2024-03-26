defmodule AtomicWeb.Components.Popover do
  @moduledoc """
  Renders a popover.
  """

  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :type, :atom,
    values: [:user, :organization, :button],
    default: :user,
    doc: "The type of entity associated with the avatar."

  attr :position, :atom,
    values: [:top, :right, :bottom, :left],
    required: true,
    doc: "The position of the popover."

  attr :organization, :map, default: %{}, doc: "The organization to render."
  attr :user, :map, default: %{}, doc: "The user to render."
  attr :button, :map, default: %{}, doc: "The button to render."

  slot :wrapper,
    required: true,
    doc: "Slot to be rendered as a wrapper of the popover. For example, a avatar."

  def popover(assigns) do
    ~H"""
    <div class="group relative h-min">
      <%= render_slot(@wrapper) %>
      <div class={[
        "hidden z-50 group-hover:block transition delay-700 duration-300 ease-in-out",
        triangle_class(position: @position)
      ]}>
        <div class={[
          "absolute z-50 w-64 bg-slate-50 border border-gray-200 rounded-lg shadow-md",
          popover_position(position: @position)
        ]}>
          <%= render_popover(assigns, type: @type) %>
        </div>
      </div>
    </div>
    """
  end

  def triangle_class(position: :bottom) do
    "before:border-l-[10px] before:border-b-[10px] before:border-r-[10px] before:absolute before:mx-3 before:mb-8 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def triangle_class(position: :top) do
    "before:bottom-full before:border-l-[10px] before:border-t-[10px] before:border-r-[10px] before:absolute before:mx-3 before:mt-8 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def triangle_class(position: :left) do
    "before:right-full before:bottom-0 before:border-t-[10px] before:border-l-[10px] before:border-b-[10px] before:absolute before:mt-9 before:border-t-transparent before:border-l-gray-200 before:border-b-transparent"
  end

  def triangle_class(position: :right) do
    "before:left-full before:bottom-0 before:border-t-[10px] before:border-r-[10px] before:border-b-[10px] before:absolute before:mt-9 before:border-t-transparent before:border-r-gray-200 before:border-b-transparent"
  end

  def popover_position(position: :bottom) do
    "mt-2"
  end

  def popover_position(position: :top) do
    "bottom-full mb-2"
  end

  def popover_position(position: :right) do
    "left-full mx-2 top-0"
  end

  def popover_position(position: :left) do
    "right-full mx-2 top-0"
  end

  def render_popover(assigns, type: :organization) do
    ~H"""
    <div class="relative p-3">
      <div class="mb-2 mb-4 flex items-center justify-between">
        <.avatar name={@organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} />
      </div>
      <p class="text-base font-semibold leading-none text-gray-900">
        <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @organization.id)}>
          <%= @organization.name %>
        </.link>
      </p>
      <p class="text-sm text-gray-500 dark:text-gray-400">
        <%= @organization.description %>
      </p>
    </div>
    """
  end

  def render_popover(assigns, type: :button) do
    ~H"""
    <div class="relative p-3">
      <div class="mb-2 mb-4 items-center justify-between">
        <p class="text-base font-semibold leading-none text-gray-900">
            <%= @button.name %>
        </p>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-4">
          <%= @button.description %>
        </p>
      </div>
    </div>
    """
  end
end
