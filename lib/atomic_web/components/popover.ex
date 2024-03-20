defmodule AtomicWeb.Components.Popover do
  @moduledoc """
  Renders a popover.
  """

  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :type, :atom, values: [:user, :organization], default: :user, doc: "The type of entity associated with the avatar."
  attr :organization, :map, default: %{}, doc: "The organization to render."
  attr :user, :map, default: %{}, doc: "The user to render."

  def popover(assigns) do
    ~H"""
      <div data-popover id="organization" class="absolute z-10 invisible inline-block w-64 text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 dark:text-gray-400 dark:bg-gray-800 dark:border-gray-600">
          <%= render_organization_popover(assigns) %>
      </div>
    """
  end

  def render_organization_popover(assigns) do
    ~H"""
      <div class="p-3">
          <div class="flex items-center justify-between mb-2">
              <.avatar name={@organization.name} color={:light_gray} class="!h-10 !w-10" size={:xs} type={:organization} src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} />
              <div>
                  <button type="button" class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-xs px-3 py-1.5 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">Follow</button>
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
