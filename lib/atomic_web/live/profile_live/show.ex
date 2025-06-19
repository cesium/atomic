defmodule AtomicWeb.ProfileLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Tabs, Avatar, Gradient, Socials}
  import AtomicWeb.Components.ImageUploader
  import AtomicWeb.LiveHelpers

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

    is_following =
      if Map.has_key?(socket.assigns, :current_user) do
        Organizations.list_memberships(%{"user_id" => user.id}, [:organization]) != []
      else
        false
      end

    {:noreply,
     socket
     |> assign(:page_title, user.name)
     |> assign_page_metadata(:user_profile)
     |> assign(:current_page, :profile)
     |> assign(:user, user)
     |> assign(:organizations, organizations)
     |> assign(:memberships, memberships)
     |> assign(:is_current_user, is_current_user)
     |> assign(:current_tab, current_tab(socket, params))
     |> assign(:is_following, is_following)}
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
        # Reload memberships after successful unfollow
        memberships =
          Organizations.list_memberships(%{"user_id" => socket.assigns.user.id}, [:organization])

        # Handle the case when memberships might be nil or empty
        is_following = memberships != nil && Enum.any?(memberships)

        {:noreply,
         socket
         |> assign(:memberships, memberships || [])
         |> assign(:is_following, is_following)
         |> put_flash(:success, "Unfollowed " <> organization.name)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to unfollow " <> organization.name)}
    end
  end

  defp current_tab(_socket, params) when is_map_key(params, "tab") do
    params["tab"]
  end

  defp current_tab(_socket, _params), do: "following"
end
