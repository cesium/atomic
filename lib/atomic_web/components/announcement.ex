defmodule AtomicWeb.Components.Announcement do
  @moduledoc """
  Renders an announcement.
  """
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Avatar

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex space-x-3">
        <div class="my-auto flex-shrink-0">
          <.avatar name={@announcement.organization.name} class="!h-10 !w-10 text-zinc-600" size={:xs} type={:organization} src={Uploaders.Logo.url({@announcement.organization.logo, @announcement.organization}, :original)} color="zinc-200" />
        </div>
        <div class="min-w-0 flex-1">
          <button phx-target={@myself} phx-click="navigate-to-organization" phx-value-organization={@announcement.organization.id} class="hover:underline focus:outline-none">
            <p class="text-sm font-medium text-gray-900">
              <%= @announcement.organization.name %>
            </p>
          </button>
          <p class="text-sm text-gray-500">
            <span class="sr-only">Published on</span>
            <time><%= relative_datetime(@announcement.inserted_at) %></time>
          </p>
        </div>
      </div>
      <h2 class="mt-3 text-base font-semibold text-gray-900"><%= @announcement.title %></h2>
      <div class="space-y-4 text-justify text-sm text-gray-700">
        <%= @announcement.description %>
      </div>
      <!-- Image -->
      <%= if @announcement.image do %>
        <div class="mt-4">
          <img class="max-w-screen rounded-md sm:max-w-xl" src={Uploaders.Post.url({@announcement.image, @announcement}, :original)} />
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("navigate-to-organization", %{"organization" => organization_id}, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.organization_show_path(socket, :show, organization_id))}
  end
end
