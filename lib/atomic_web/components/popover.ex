defmodule AtomicWeb.Components.Popover do
  @moduledoc """
  Renders a popover.
  """

  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :type, :atom,
    values: [:user, :organization],
    default: :user,
    doc: "The type of entity associated with the avatar."

  attr :position, :atom,
    values: [:top, :right, :bottom, :left],
    required: true,
    doc: "The position of the popover."

  attr :organization, :map, default: %{}, doc: "The organization to render."
  attr :user, :map, default: %{}, doc: "The user to render."

  slot :wrapper,
    required: true,
    doc: "Slot to be rendered as a wrapper of the popover. For example, a avatar."

  def popover(assigns) do
    ~H"""
    <div class="group relative h-min">
      <%= render_slot(@wrapper) %>
      <div class={[
        "hidden group-hover:block transition-all delay-700 duration-300 ease-in-out",
        triangle_class(position: @position)
      ]}>
        <div class="absolute mt-2 z-50 w-64 bg-slate-50 border border-gray-200 rounded-lg shadow-md hidden group-hover:block transition-all delay-700 duration-300 ease-in-out">
          <%= render_popover(assigns, type: @type) %>
        </div>
      </div>
    </div>
    """
  end

  def triangle_class(position: :bottom) do
    "before:border-l-[10px] before:border-b-[10px] before:border-r-[10px] before:absolute before:mb-8 before:h-0 before:w-0 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def triangle_class(position: :top) do
    "before:border-l-[10px] before:border-t-[10px] before:border-r-[10px] before:absolute before:mx-3 before:mb-8 before:h-0 before:w-0 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def triangle_class(position: :left) do
    "before:border-t-[10px] before:border-l-[10px] before:border-b-[10px] before:absolute before:mx-3 before:mb-8 before:h-0 before:w-0 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def triangle_class(position: :right) do
    "before:border-t-[10px] before:border-r-[10px] before:border-b-[10px] before:absolute before:mx-3 before:mb-8 before:h-0 before:w-0 before:border-r-transparent before:border-b-gray-200 before:border-l-transparent"
  end

  def render_popover(assigns, type: :organization) do
    ~H"""
    <div class="relative p-3">
      <div class="mb-2 mb-4 flex items-center justify-between">
        <.avatar name={@organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} />
        <div>
          <button type="button" class="rounded-lg bg-orange-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-orange-800 focus:outline-none focus:ring-4 focus:ring-orange-300 dark:bg-orange-700 dark:hover:bg-orange-700 dark:focus:ring-orange-800">Follow</button>
        </div>
      </div>
      <p class="text-base font-semibold leading-none text-gray-900 dark:text-white">
        <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @organization.id)}>
          <%= @organization.name %>
        </.link>
      </p>
      <p class="text-sm text-gray-500 dark:text-gray-400">
        <%= @organization.description %>
      </p>
    </div>
    <div data-popper-arrow></div>
    """
  end

end
