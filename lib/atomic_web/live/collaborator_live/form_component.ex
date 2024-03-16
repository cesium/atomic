defmodule AtomicWeb.CollaboratorLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Avatar
  import AtomicWeb.Components.Badge

  alias Atomic.Departments
  alias Phoenix.LiveView.JS

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
      <div class="flex flex-col sm:flex-row">
        <.link navigate={Routes.profile_show_path(@socket, :show, @collaborator.user)} class="mt-4 flex outline-none">
          <.avatar color={:light_gray} name={@collaborator.user.name} />
          <div class="ml-3 flex h-full flex-col self-center">
            <p><%= @collaborator.user.name %></p>
            <p>@<%= @collaborator.user.slug %></p>
          </div>
        </.link>
        <%= if @collaborator.accepted do %>
          <.badge variant={:outline} color={:success} size={:md} class="my-5 select-none rounded-xl py-1 font-normal sm:ml-auto sm:py-0">
            <p>Collaborator since <%= display_date(@collaborator.inserted_at) %></p>
          </.badge>
        <% else %>
          <.badge variant={:outline} color={:warning} size={:md} class="bg-yellow-300/5 my-5 select-none rounded-xl border-yellow-400 py-1 font-normal text-yellow-400 sm:ml-auto sm:py-0">
            <p>Not accepted</p>
          </.badge>
        <% end %>
      </div>
      <!-- Action Buttons -->
      <div class="mt-8 flex space-x-2">
        <%= if @collaborator.accepted do %>
          <.button phx-click="delete" phx-target={@myself} size={:lg} icon={:x_circle} color={:white} full_width>Delete</.button>
        <% else %>
          <.button phx-click="deny" phx-target={@myself} size={:lg} icon={:x_circle} color={:white} full_width>Deny</.button>
          <.button phx-click="allow" phx-target={@myself} size={:lg} icon={:check_circle} color={:white} full_width>Accept</.button>
        <% end %>
      </div>
      <!-- Action Confirm Modal -->
      <.modal :if={@action_modal} id="action-confirm-modal" show on_cancel={JS.push("clear-action", target: @myself)}>
        <div class="flex flex-col">
          <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900">
            <%= display_action_goal_confirm_title(@action_modal) %>
          </h1>
          <p class="mt-4">
            <%= display_action_goal_confirm_description(@action_modal, @department) %>
          </p>
          <div class="mt-8 flex flex-row-reverse">
            <.button
              phx-click="confirm"
              class="ml-2"
              phx-target={@myself}
              size={:lg}
              icon={:check_circle}
              color={
                if @action_modal != :delete_collaborator do
                  :white
                else
                  :danger
                end
              }
              full_width
            >
              Confirm
            </.button>
            <.button phx-click="clear-action" class="mr-2" phx-target={@myself} size={:lg} icon={:x_circle} color={:white} full_width>Cancel</.button>
          </div>
        </div>
      </.modal>
    </div>
    """
  end

  @impl true
  def update(%{collaborator: collaborator} = assigns, socket) do
    changeset = Departments.change_collaborator(collaborator)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:action_modal, nil)
     |> assign(:changeset, changeset)}
  end

  defp confirm_collaborator_request(socket) do
    {:noreply, socket}
  end

  defp deny_collaborator_request(socket) do
    {:noreply, socket}
  end

  defp delete_collaborator(socket) do
    with {:ok, _} <- Departments.delete_collaborator(socket.assigns.collaborator) do
      send(
        self(),
        {:change_collaborator,
         %{status: :success, message: gettext("Collaborator removed successfully.")}}
      )

      {:noreply, socket |> assign(:action_modal, nil)}
    else
      _ ->
        send(
          self(),
          {:change_collaborator,
           %{
             status: :error,
             message: gettext("Could not delete the collaborator. Please try again later.")
           }}
        )

        {:noreply, socket |> assign(:action_modal, nil)}
    end
  end

  @impl true
  def handle_event("confirm", _, socket) do
    case socket.assigns.action_modal do
      :confirm_request -> confirm_collaborator_request(socket)
      :deny_request -> deny_collaborator_request(socket)
      :delete_collaborator -> delete_collaborator(socket)
    end
  end

  @impl true
  def handle_event("clear-action", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, nil)}
  end

  @impl true
  def handle_event("allow", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, :confirm_request)}
  end

  @impl true
  def handle_event("deny", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, :deny_request)}
  end

  @impl true
  def handle_event("delete", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, :delete_collaborator)}
  end

  defp display_action_goal_confirm_title(action) do
    case action do
      :confirm_request ->
        gettext("Are you sure you want to accept this request?")

      :deny_request ->
        gettext("Are you sure you want to deny this request?")

      :delete_collaborator ->
        gettext("Are you sure you want to remove this person from the department?")
    end
  end

  defp display_action_goal_confirm_description(action, department) do
    case action do
      :confirm_request ->
        gettext("If you change your mind you can always remove this person later.")

      :deny_request ->
        gettext("If you deny this request, this person will not get access to the department.")

      :delete_collaborator ->
        gettext(
          "If you remove this person, they will no longer have access to %{department_name}.",
          department_name: department.name
        )
    end
  end
end
