defmodule AtomicWeb.HomeLive.Components.FollowSuggestions.Suggestion do
  @moduledoc false
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Avatar

  alias Atomic.Organizations

  attr :organization, :map,
    required: true,
    doc: "The organization to display."

  attr :current_user, :map,
    required: true,
    doc: "The current user logged in."

  attr :is_following, :boolean,
    default: false,
    doc: "Current user follow state for the organization."

  @impl true
  def render(assigns) do
    ~H"""
    <li class="flex items-center space-x-3">
      <.link navigate={Routes.organization_show_path(AtomicWeb.Endpoint, :show, @organization)} class="flex min-w-0 flex-1 items-center space-x-3 py-4">
        <div class="my-auto flex-shrink-0">
          <.avatar name={@organization.name} class="!h-10 !w-10 !text-lg" color={:light_gray} size={:xs} type={:organization} src={Uploaders.Logo.url({@organization.logo, @organization}, :original)} />
        </div>
        <div class="min-w-0 flex-1">
          <p class="text-sm font-medium text-gray-900">
            <%= @organization.name %>
          </p>
          <p class="text-sm text-gray-500">
            <!-- FIXME: organization.handle -->
            <%= ("@" <> @organization.name) |> String.downcase() |> String.replace(" ", "") %>
          </p>
        </div>
      </.link>
      <div class="flex-shrink-0">
        <%= if @is_following do %>
          <.button phx-value-organization_id={@organization.id} phx-click="unfollow" phx-target={@myself} color={:white} size={:xs}>
            <.icon name="hero-minus-solid" class="size-5 text-gray-400" />
            <span>Unfollow</span>
          </.button>
        <% else %>
          <.button phx-value-organization_id={@organization.id} phx-click="follow" phx-target={@myself} color={:white} size={:xs}>
            <.icon name="hero-plus" class="size-5 text-gray-400" />
            <span>Follow</span>
          </.button>
        <% end %>
      </div>
    </li>
    """
  end

  def handle_event("follow", _params, socket) when is_nil(socket.assigns.current_user) do
    {:noreply,
     socket
     |> put_flash(:info, "You must be logged in to follow organizations")
     |> redirect(to: Routes.user_session_path(AtomicWeb.Endpoint, :new))}
  end

  @impl true
  def handle_event("follow", %{"organization_id" => organization_id} = _params, socket) do
    attrs = %{
      role: :follower,
      user_id: socket.assigns.current_user.id,
      created_by_id: socket.assigns.current_user.id,
      organization_id: organization_id
    }

    organization = Organizations.get_organization!(organization_id)

    case Organizations.create_membership(attrs) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> assign(:is_following, true)
         |> put_flash(:success, "Started following " <> organization.name)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("unfollow", %{"organization_id" => organization_id} = _params, socket) do
    membership =
      Organizations.get_membership_by_user_id_and_organization_id!(
        socket.assigns.current_user.id,
        organization_id
      )

    organization = Organizations.get_organization!(organization_id)

    case Organizations.delete_membership(membership) do
      {:ok, _organization} ->
        {:noreply,
         socket
         |> assign(:is_following, false)
         |> put_flash(:success, "Unfollowed " <> organization.name)}
    end
  end
end
