defmodule AtomicWeb.ProfileLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Tabs, Avatar, Gradient, Socials}
  import AtomicWeb.Components.ImageUploader
  import AtomicWeb.LiveHelpers
  alias AtomicWeb.HomeLive.Components.FollowSuggestions.Suggestion

  alias Atomic.Accounts
  alias Atomic.Organizations

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> allow_upload(:profile_picture,
       accept: @extensions_whitelist,
       max_entries: 1,
       max_file_size: 10_000_000
     )
     |> allow_upload(:banner,
       accept: @extensions_whitelist,
       max_entries: 1,
       max_file_size: 100_000_000
     )}
  end

  @impl true
  def handle_params(%{"slug" => user_slug} = params, _, socket) do
    user = Accounts.get_user_by_slug(user_slug)

    is_current_user =
      Map.has_key?(socket.assigns, :current_user) and socket.assigns.current_user.id == user.id

    organizations = Organizations.list_user_organizations(user.id)

    memberships = Organizations.list_memberships(%{"user_id" => user.id}, [:organization])

    {:noreply,
     socket
     |> assign(:page_title, user.name)
     |> assign_page_metadata(:user_profile)
     |> assign(:current_page, :profile)
     |> assign(:user, user)
     |> assign(:organizations, organizations)
     |> assign(:memberships, memberships)
     |> assign(:is_current_user, is_current_user)
     |> assign(:current_tab, current_tab(socket, params))}
  end

  @impl true
  def handle_event("unfollow", %{"organization_id" => organization_id}, socket) do
    membership =
      Organizations.get_membership_by_user_id_and_organization_id!(
        socket.assigns.current_user.id,
        organization_id
      )

    organization = Organizations.get_organization!(organization_id)

    case Organizations.delete_membership(membership) do
      {:ok, _organization} ->
        # Reloads memberships list after unfollowing a new one
        memberships =
          Organizations.list_memberships(%{"user_id" => socket.assigns.user.id}, [:organization])

        {:noreply,
         socket
         |> assign(:memberships, memberships || [])
         |> put_flash(:success, "Unfollowed " <> organization.name)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to unfollow " <> organization.name)}
    end
  end

  @impl true
  def handle_event("follow", %{"organization_id" => organization_id}, socket) do
    attrs = %{
      role: :follower,
      user_id: socket.assigns.current_user.id,
      created_by_id: socket.assigns.current_user.id,
      organization_id: organization_id
    }

    organization = Organizations.get_organization!(organization_id)

    case Organizations.create_membership(attrs) do
      {:ok, _organization} ->
        # Reloads memberships list after following a new one
        memberships =
          Organizations.list_memberships(%{"user_id" => socket.assigns.user.id}, [:organization])

        {:noreply,
         socket
         |> assign(:memberships, memberships || [])
         |> put_flash(:success, "Started following " <> organization.name)
         |> push_patch(to: ~p"/profile/#{socket.assigns.user.slug}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab") do
    params["tab"]
  end

  defp current_tab(_socket, _params), do: "following"
end
