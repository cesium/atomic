defmodule AtomicWeb.CollaboratorLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Avatar

  alias Atomic.Departments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900">Collaborator</h1>
      <!-- Request notification -->
      <%= if !@collaborator.accepted do %>
        <p class="mt-1"><%= extract_first_name(@collaborator.user.name) %> has requested to be a collaborator of <%= @department.name %>.</p>
      <% end %>
      <!-- User Card -->
      <div class="mt-4 flex">
        <.avatar name={@collaborator.user.name} />
        <div class="ml-3 flex h-full flex-col self-center">
          <p><%= @collaborator.user.name %></p>
          <p>@<%= @collaborator.user.slug %></p>
        </div>
        <%= if @collaborator.accepted do %>
          <div class="bg-green-300/5 ml-auto select-none self-center rounded-xl border border-green-300 px-3 py-2 text-green-400">
            <p>Collaborator since <%= display_date(@collaborator.inserted_at) %></p>
          </div>
        <% else %>
          <div class="bg-yellow-300/5 ml-auto select-none self-center rounded-xl border border-yellow-300 px-3 py-2 text-yellow-400">
            <p>Not accepted</p>
          </div>
        <% end %>
      </div>
      <!-- Action Buttons -->
      <div class="mt-8 flex">
        <%= if @collaborator.accepted do %>
          <button phx-click="remove" class="ml-2 flex-1 rounded-lg border border-gray-300 bg-white px-4 py-2 text-gray-900 hover:bg-gray-50">
            <div class="flex items-center justify-center">
              <Heroicons.x_circle class="mr-2 h-5 w-5" /> Remove
            </div>
          </button>
        <% else %>
          <button phx-click="accept" class="mr-2 flex-1 rounded-lg border border-gray-300 bg-white px-4 py-2 text-gray-900 hover:bg-gray-50">
            <div class="flex items-center justify-center">
              <Heroicons.check_circle class="mr-2 h-5 w-5" /> Accept
            </div>
          </button>
          <button phx-click="remove" class="ml-2 flex-1 rounded-lg border border-gray-300 bg-white px-4 py-2 text-gray-900 hover:bg-gray-50">
            <div class="flex items-center justify-center">
              <Heroicons.x_circle class="mr-2 h-5 w-5" /> Deny
            </div>
          </button>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{collaborator: collaborator} = assigns, socket) do
    changeset = Departments.change_collaborator(collaborator)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end
end
