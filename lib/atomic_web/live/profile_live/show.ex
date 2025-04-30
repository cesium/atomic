defmodule AtomicWeb.ProfileLive.Show do
  use AtomicWeb, :live_view

  import AtomicWeb.Components.{Button, Avatar, Gradient, Socials}
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
  def handle_params(%{"slug" => user_slug}, _, socket) do
    user = Accounts.get_user_by_slug(user_slug)

    is_current_user =
      Map.has_key?(socket.assigns, :current_user) and socket.assigns.current_user.id == user.id

    organizations = Organizations.list_user_organizations(user.id)

    {:noreply,
     socket
     |> assign(:page_title, user.name)
     |> assign_page_metadata(:user_profile)
     |> assign(:current_page, :profile)
     |> assign(:user, user)
     |> assign(:organizations, organizations)
     |> assign(:is_current_user, is_current_user)}
  end
end
