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
        <div class="flex mt-4">
          <.avatar name={@collaborator.user.name} />
          <div class="ml-3 h-full flex flex-col self-center">
            <p><%= @collaborator.user.name %></p>
            <p>@<%= @collaborator.user.slug %></p>
          </div>
          <%= if @collaborator.accepted do %>
            <div class="ml-auto self-center border text-green-400 border-green-300 bg-green-300/5 select-none rounded-xl px-3 py-2">
              <p>Collaborator since <%= display_date(@collaborator.inserted_at) %></p>
            </div>
          <% else %>
            <div class="ml-auto self-center border text-yellow-400 border-yellow-300 bg-yellow-300/5 select-none rounded-xl px-3 py-2">
              <p>Not accepted</p>
            </div>
          <% end %>
        </div>
        <!-- Action Buttons -->
        <div class="flex mt-8">
          <%= if @collaborator.accepted do %>
            <button phx-click="remove" class="flex-1 ml-2 bg-white border border-gray-300 text-gray-900 rounded-lg py-2 px-4 hover:bg-gray-50">
              <div class="flex justify-center items-center">
                <Heroicons.x_circle class="h-5 w-5 mr-2" />
                Remove
              </div>
            </button>
          <% else %>
            <button phx-click="accept" class="flex-1 mr-2 bg-white border border-gray-300 text-gray-900 rounded-lg py-2 px-4 hover:bg-gray-50">
              <div class="flex justify-center items-center">
                <Heroicons.check_circle class="h-5 w-5 mr-2" />
                Accept
              </div>
            </button>
            <button phx-click="remove" class="flex-1 ml-2 bg-white border border-gray-300 text-gray-900 rounded-lg py-2 px-4 hover:bg-gray-50">
              <div class="flex justify-center items-center">
                <Heroicons.x_circle class="h-5 w-5 mr-2" />
                Deny
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
