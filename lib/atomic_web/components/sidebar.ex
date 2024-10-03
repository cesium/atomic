defmodule AtomicWeb.Components.Sidebar do
  @moduledoc false
  use AtomicWeb, :component

  alias Phoenix.LiveView.JS
  import AtomicWeb.Components.Icon
  alias Atomic.Organizations
  alias Atomic.Uploaders.ProfilePicture

  attr :current_user, :map, required: true
  attr :current_organization, :map, required: true
  attr :current_page, :atom, required: true
  attr :is_authenticated, :boolean, required: true

  def desktop_sidebar(assigns) do
    user = assigns[:current_user]
    organizations = get_organizations(user)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="relative z-50 hidden" role="dialog">
      <.sidebar_header />
      <.sidebar_list current_user={@current_user} current_organization={@current_organization} current_page={@current_page} />
    </div>
    <!-- Navigation -->
    <.navigation current_user={@current_user} current_organization={@current_organization} current_page={@current_page} is_authenticated={@is_authenticated} />
    """
  end

  def mobile_sidebar(assigns) do
    user = assigns[:current_user]
    organizations = get_organizations(user)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="relative z-50 lg:hidden">
      <div class="flex flex-row items-center justify-between">
        <button type="button" class="-m-2.5 pl-6 text-zinc-700 lg:hidden" phx-click={show_mobile_sidebar()}>
          <span class="sr-only">Open sidebar</span>
          <.icon name="hero-bars-3" class="!h-6 !w-6" />
        </button>
        <div class="left-1/4 mt-auto -mb-2">
          <span class="sr-only">Open user menu</span>
          <.sidebar_dropdown current_user={@current_user} orientation={:down} />
        </div>
      </div>
      <div id="sidebar-overlay" class="fixed inset-0 z-40 hidden cursor-pointer bg-black bg-opacity-50" phx-click={hide_mobile_sidebar()}></div>
      <!-- Sidebar Panel -->
      <div id="mobile-sidebar" class="fixed inset-0 z-50 hidden w-64" role="dialog" aria-modal="true">
        <div class="fixed inset-0 flex w-fit">
          <div class="relative flex w-64 max-w-xs flex-col border-r bg-white">
            <div class="flex justify-between p-4">
              <.sidebar_header />

              <button type="button" phx-click={hide_mobile_sidebar()} class="absolute top-0 right-0 p-4">
                <span class="sr-only">Close sidebar</span>
                <.icon name="hero-x-mark" class="size-6 text-zinc-700" />
              </button>
            </div>

            <div class="flex-1 overflow-y-auto px-4 py-4">
              <.sidebar_list current_user={@current_user} current_organization={@current_organization} current_page={@current_page} />
              <%= if Enum.count(@organizations) > 0 do %>
                <div class="text-xs font-semibold leading-6 text-zinc-400"><%= gettext("Your organizations") %></div>
                <.live_component id="mobile-organizations" module={AtomicWeb.Components.Organizations} current_user={@current_user} current_organization={@current_organization} organizations={@organizations} />
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp navigation(assigns) do
    user = assigns[:current_user]
    organizations = get_organizations(user)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col">
      <div class="flex grow flex-col gap-y-5 overflow-y-auto border-r border-zinc-200 bg-white px-6 pb-4">
        <.sidebar_header />
        <.sidebar_list current_user={@current_user} current_organization={@current_organization} current_page={@current_page} />
        <!-- Organizations listing -->
        <%= if Enum.count(@organizations) > 0 do %>
          <div class="text-xs font-semibold leading-6 text-zinc-400"><%= gettext("Your organizations") %></div>
          <.live_component id="desktop-organizations" module={AtomicWeb.Components.Organizations} current_user={@current_user} current_organization={@current_organization} organizations={@organizations} />
        <% end %>
        <!-- Sidebar -->
        <div class="absolute bottom-0 w-full">
          <.sidebar_dropdown current_user={@current_user} orientation={:up} />
        </div>
      </div>
    </div>
    """
  end

  defp sidebar_list(assigns) do
    ~H"""
    <ul role="list" class="-mx-2 space-y-1">
      <%= for page <- AtomicWeb.Config.pages(@current_user, @current_organization) do %>
        <li class="select-none">
          <.link navigate={page.url} class={"#{if @current_page == page.key do "bg-zinc-50 text-orange-500" else "text-zinc-700 hover:text-orange-500 hover:bg-zinc-50" end} group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6"}>
            <.icon name={page.icon} class={
                "#{if @current_page == page.key do
                  "text-orange-500"
                else
                  "text-zinc-400 group-hover:text-orange-500"
                end} size-6 shrink-0"
              } />
            <%= page.title %>
          </.link>
        </li>
      <% end %>
    </ul>
    """
  end

  defp sidebar_dropdown(assigns) do
    ~H"""
    <%= if @current_user do %>
      <AtomicWeb.Components.Dropdown.dropdown orientation={@orientation} items={dropdown_items(@current_user)} id="user-menu-button">
        <:wrapper>
          <button class="flex w-full select-none flex-row items-center gap-x-2 px-4 py-3 text-sm font-semibold leading-6 text-zinc-700 lg:px-0">
            <AtomicWeb.Components.Avatar.avatar name={@current_user.name} src={user_image(@current_user)} size={:xs} color={:light_gray} class="!text-sm" />
            <span class="text-sm font-semibold leading-6"><%= @current_user.name %></span>
            <.icon name="hero-chevron-right-solid" class="size-5" />
          </button>
        </:wrapper>
      </AtomicWeb.Components.Dropdown.dropdown>
    <% else %>
      <.link navigate={~p"/users/log_in"} class="flex select-none items-center space-x-2 px-4 py-3 text-sm font-semibold leading-6 text-zinc-700 lg:px-0">
        <span class="text-sm font-semibold leading-6">Log in</span>
        <.icon name="hero-arrow-right-end-on-rectangle-solid" class="size-5" />
      </.link>
    <% end %>
    """
  end

  defp sidebar_header(assigns) do
    ~H"""
    <.link navigate={~p"/"} class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
      <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
      <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
    </.link>
    """
  end

  defp dropdown_items(nil), do: []
  defp dropdown_items(current_user), do: authenticated_dropdown_items(current_user)

  defp authenticated_dropdown_items(current_user) do
    [
      %{
        name: gettext("Your profile"),
        navigate: ~p"/profile/#{current_user}"
      },
      %{
        name: gettext("Sign out"),
        href: ~p"/users/log_out",
        method: "delete"
      }
    ]
  end

  defp show_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#mobile-sidebar",
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
    |> JS.show(to: "#sidebar-overlay")
    |> JS.dispatch("focus", to: "#mobile-sidebar")
  end

  defp hide_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#mobile-sidebar",
      transition:
        {"ease-out duration-300", "transform translate-x-0", "transform -translate-x-full"}
    )
    |> JS.hide(
      to: "#sidebar-overlay",
      transition: {"ease-out duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.dispatch("focus", to: "#mobile-sidebar")
  end

  defp user_image(user) do
    if user.profile_picture do
      ProfilePicture.url({user.profile_picture, user}, :original)
    else
      nil
    end
  end

  defp get_organizations(nil), do: []
  defp get_organizations(user), do: Organizations.list_user_organizations(user.id)
end
