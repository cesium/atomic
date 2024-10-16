defmodule AtomicWeb.CollaboratorLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.{Avatar, Badge}

  alias Atomic.Departments
  alias Phoenix.LiveView.JS

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900">Collaborator</h1>
      <!-- Request notification -->
      <%= if !@collaborator.accepted do %>
        <p class="mt-1">
          <%= gettext("%{user_name} has requested to be a collaborator of %{department_name}.", user_name: extract_first_name(@collaborator.user.name), department_name: @department.name) %>
        </p>
      <% end %>
      <!-- User Card -->
      <div class="flex flex-col sm:flex-row">
        <.link navigate={~p"/profile/#{@collaborator.user}"} class="mt-4 flex outline-none">
          <.avatar color={:light_gray} name={@collaborator.user.name} />
          <div class="ml-3 flex h-full flex-col self-center">
            <p><%= @collaborator.user.name %></p>
            <p>@<%= @collaborator.user.slug %></p>
          </div>
        </.link>
        <%= if @collaborator.accepted do %>
          <.badge variant={:outline} color={:success} size={:md} class="my-5 select-none rounded-xl py-1 font-normal sm:ml-auto sm:py-0">
            <p><%= gettext("Collaborator since %{accepted_at}", accepted_at: @collaborator.accepted_at) %></p>
          </.badge>
        <% else %>
          <.badge variant={:outline} color={:warning} size={:md} class="bg-yellow-300/5 my-5 select-none rounded-xl border-yellow-400 py-1 font-normal text-yellow-400 sm:ml-auto sm:py-0">
            <p><%= gettext("Not accepted") %></p>
          </.badge>
        <% end %>
      </div>
      <%= if !@collaborator.accepted do %>
        <div class="my-4 flex w-full select-none flex-row justify-center gap-2" aria-label={"#{display_date(@collaborator.inserted_at)} #{display_time(@collaborator.inserted_at)}"}>
          <.icon class="size-5 my-auto" name="hero-calendar" />
          <p><%= gettext("Requested %{requested_at}", requested_at: relative_datetime(@collaborator.inserted_at)) %></p>
        </div>
      <% end %>
      <!-- Action Buttons -->
      <div class="mt-8 flex space-x-2">
        <%= if @collaborator.accepted do %>
          <.button phx-click="delete" phx-target={@myself} size={:lg} icon="hero-x-circle" color={:white} full_width><%= gettext("Delete") %></.button>
        <% else %>
          <.button phx-click="deny" phx-target={@myself} size={:lg} icon="hero-x-circle" color={:white} full_width><%= gettext("Deny") %></.button>
          <.button phx-click="allow" phx-target={@myself} size={:lg} icon="hero-check-circle" color={:white} full_width><%= gettext("Accept") %></.button>
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
          <div class="mt-8 flex flex-row">
            <.button phx-click="clear-action" class="mr-2" phx-target={@myself} size={:lg} icon="hero-x-circle" color={:white} full_width><%= gettext("Cancel") %></.button>
            <.button
              phx-click="confirm"
              class="ml-2"
              phx-target={@myself}
              size={:lg}
              icon="hero-check-circle"
              color={
                if @action_modal in [:delete_collaborator, :deny_request] do
                  :danger
                else
                  :success
                end
              }
              full_width
            >
              <%= gettext("Confirm") %>
            </.button>
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

  defp deny_collaborator_request(socket) do
    case Departments.delete_collaborator(socket.assigns.collaborator) do
      {:ok, _} ->
        notify_result(socket, :success, gettext("Collaborator request denied."))

      _ ->
        notify_result(
          socket,
          :error,
          gettext("Could not deny the collaborator request. Please try again later.")
        )
    end
  end

  defp delete_collaborator(socket) do
    case Departments.delete_collaborator(socket.assigns.collaborator) do
      {:ok, _} ->
        notify_result(socket, :success, gettext("Collaborator removed successfully."))

      _ ->
        notify_result(
          socket,
          :error,
          gettext("Could not delete the collaborator. Please try again later.")
        )
    end
  end

  defp accept_collaborator_request(socket) do
    case Departments.accept_collaborator_request(socket.assigns.collaborator) do
      {:ok, _} ->
        notify_result(socket, :success, gettext("Collaborator accepted successfully."))

      _ ->
        notify_result(
          socket,
          :error,
          gettext("Could not accept the collaborator. Please try again later.")
        )
    end
  end

  defp notify_result(socket, status, message) do
    send(self(), {:change_collaborator, %{status: status, message: message}})
    {:noreply, assign(socket, :action_modal, nil)}
  end

  @impl true
  def handle_event("confirm", _, socket) do
    case socket.assigns.action_modal do
      :confirm_request -> accept_collaborator_request(socket)
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
