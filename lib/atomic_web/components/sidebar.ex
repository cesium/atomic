defmodule AtomicWeb.Components.Sidebar do
  @moduledoc false
  use AtomicWeb, :component

  alias Phoenix.LiveView.JS
  import AtomicWeb.Components.{Avatar, Dropdown, Icon}
  alias Atomic.Organizations

  attr :current_user, :map, required: true
  attr :current_organization, :map, required: true
  attr :current_page, :atom, required: true
  attr :is_authenticated, :boolean, required: true

  def desktop_sidebar(assigns) do
    user = assigns[:current_user]
    organizations = Organizations.list_user_organizations(user.id)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="relative z-50 hidden" role="dialog" aria-modal="true" id="desktop-sidebar">
      <div class="bg-zinc-900/80 fixed inset-0"></div>
      <div class="fixed inset-0 flex" id="desktop-sidebar-content">
        <div class="relative mr-16 flex w-full max-w-xs flex-1">
          <div class="flex grow flex-col gap-y-5 overflow-y-auto bg-white px-6 pb-4">
            <.link navigate={Routes.home_index_path(AtomicWeb.Endpoint, :index)} class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
              <img src={Routes.static_path(AtomicWeb.Endpoint, "/images/atomic.svg")} class="h-12 w-auto" />
              <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
            </.link>
            <nav class="flex flex-1 flex-col">
              <ul role="list" class="flex flex-1 flex-col gap-y-7">
                <li>
                  <ul role="list" class="-mx-2 space-y-1">
                    <%= for page <- AtomicWeb.Config.pages(AtomicWeb.Endpoint, @current_user, @current_organization) do %>
                      <li class="select-none">
                        <%= live_redirect to: page.url, class: "#{if @current_page == page.key do "bg-zinc-50 text-orange-500" else "text-zinc-700 hover:text-orange-500 hover:bg-zinc-50" end} group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6" do %>
                          <.icon
                            name={page.icon}
                            class={
                            "#{if @current_page == page.key do
                              "text-orange-500"
                            else
                              "text-zinc-400 group-hover:text-orange-500"
                            end} h-6 w-6 shrink-0"
                          }
                          />
                          <%= page.title %>
                        <% end %>
                      </li>
                    <% end %>
                  </ul>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
    </div>
    <!-- Navigation -->
    <.navigation current_user={@current_user} current_organization={@current_organization} current_page={@current_page} is_authenticated={@is_authenticated} />
    """
  end

  def mobile_sidebar(assigns) do
    user = assigns[:current_user]
    organizations = Organizations.list_user_organizations(user.id)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="relative z-50 lg:hidden">
      <button
        type="button"
        phx-click={
          %JS{}
          |> JS.show(to: "#mobile-sidebar", transition: {"ease-in duration-300", "transform -translate-x-full", "transform translate-x-0"})
          |> JS.show(to: "#sidebar-overlay", transition: {"ease-in duration-75", "opacity-0", "opacity-80"})
        }
        class="fixed top-4 right-2 z-50"
      >
        <span class="sr-only">Open sidebar</span>
        <.icon name={:bars_3} class="h-6 w-6" />
      </button>

      <div
        id="sidebar-overlay"
        class="bg-zinc-900/80 pointer-events-none fixed inset-0 z-40 opacity-0 transition-opacity duration-300"
        phx-click={
          %JS{}
          |> JS.hide(to: "#mobile-sidebar", transition: {"ease-in duration-300", "transform translate-x-0", "transform -translate-x-full"})
          |> JS.hide(to: "#sidebar-overlay", transition: {"ease-in duration-75", "opacity-80", "opacity-0"})
        }
      />
      <!-- Sidebar Panel -->
      <div id="mobile-sidebar" class="fixed inset-0 z-50 hidden -translate-x-full transform transition-transform duration-300" role="dialog" aria-modal="true">
        <div class="fixed inset-0 flex">
          <div class="relative flex w-64 max-w-xs flex-col bg-white">
            <div class="flex justify-between p-4">
              <div class="flex items-center gap-x-4">
                <img src={Routes.static_path(AtomicWeb.Endpoint, "/images/atomic.svg")} class="h-10 w-auto" />
                <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
              </div>
              <button
                type="button"
                phx-click={
                  %JS{}
                  |> JS.hide(to: "#mobile-sidebar", transition: {"ease-out duration-300", "transform translate-x-0", "transform -translate-x-full"})
                  |> JS.hide(to: "#sidebar-overlay", transition: {"ease-out duration-75", "opacity-80", "opacity-0"})
                }
                class="absolute top-0 right-0 p-4"
              >
                <span class="sr-only">Close sidebar</span>
                <.icon name={:x_mark} class="h-6 w-6 text-zinc-700" />
              </button>
            </div>
            <div class="flex-1 overflow-y-auto px-4 py-4">
              <nav class="flex flex-col gap-y-4">
                <ul role="list" class="space-y-1">
                  <%= for page <- AtomicWeb.Config.pages(AtomicWeb.Endpoint, @current_user, @current_organization) do %>
                    <li class="select-none">
                      <%= live_redirect to: page.url, class: "#{if @current_page == page.key do "bg-zinc-50 text-orange-500" else "text-zinc-700 hover:text-orange-500 hover:bg-zinc-50" end} group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6" do %>
                        <.icon
                          name={page.icon}
                          class={
                            "#{if @current_page == page.key do
                              "text-orange-500"
                            else
                              "text-zinc-400 group-hover:text-orange-500"
                            end} h-6 w-6 shrink-0"
                          }
                        />
                        <%= page.title %>
                      <% end %>
                    </li>
                  <% end %>
                </ul>
              </nav>
              <%= if @is_authenticated do %>
                <%= if Enum.count(@organizations) > 0 do %>
                  <div class="text-xs font-semibold leading-6 text-zinc-400"><%= gettext("Your organizations") %></div>
                  <.live_component id="mobile-organizations" module={AtomicWeb.Components.Organizations} current_user={@current_user} current_organization={@current_organization} organizations={@organizations} />
                <% end %>
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
    organizations = Organizations.list_user_organizations(user.id)
    assigns = assign(assigns, :organizations, organizations)

    ~H"""
    <div class="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col">
      <div class="flex grow flex-col gap-y-5 overflow-y-auto border-r border-zinc-200 bg-white px-6 pb-4">
        <.link navigate={Routes.home_index_path(AtomicWeb.Endpoint, :index)} class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
          <img src={Routes.static_path(AtomicWeb.Endpoint, "/images/atomic.svg")} class="h-14 w-auto" />
          <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
        </.link>
        <nav class="flex flex-1 flex-col">
          <ul role="list" class="flex flex-1 flex-col gap-y-7">
            <li>
              <ul role="list" class="-mx-2 space-y-1">
                <%= for page <- AtomicWeb.Config.pages(AtomicWeb.Endpoint, @current_user, @current_organization) do %>
                  <li class="select-none">
                    <%= live_redirect to: page.url, class: "#{if @current_page == page.key do "bg-zinc-50 text-orange-500" else "text-zinc-700 hover:text-orange-500 hover:bg-zinc-50" end} group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6" do %>
                      <.icon name={page.icon} class={
                        "#{if @current_page == page.key do
                          "text-orange-500"
                        else
                          "text-zinc-400 group-hover:text-orange-500"
                        end} h-6 w-6 shrink-0"
                      } />
                      <%= page.title %>
                    <% end %>
                  </li>
                <% end %>
              </ul>
            </li>
            <%= if @is_authenticated do %>
              <!-- Organizations listing -->
              <%= if Enum.count(@organizations) > 0 do %>
                <li>
                  <div class="text-xs font-semibold leading-6 text-zinc-400"><%= gettext("Your organizations") %></div>
                  <.live_component id="desktop-organizations" module={AtomicWeb.Components.Organizations} current_user={@current_user} current_organization={@current_organization} organizations={@organizations} />
                </li>
              <% end %>
              <!-- Profile menu or "Sign in" -->
              <li class="left-1/4 -mx-6 mt-auto -mb-2">
                <span class="sr-only">Open user menu</span>
                <.dropdown orientation={:up} items={dropdown_items(@current_user)} id="user-menu-button">
                  <:wrapper>
                    <button class="flex select-none items-center gap-x-4 px-12 py-3 text-sm font-semibold leading-6 text-zinc-700">
                      <.avatar
                        name={@current_user.name}
                        src={
                          if @current_user.profile_picture do
                            Uploaders.ProfilePicture.url({@current_user, @current_user.profile_picture}, :original)
                          else
                            nil
                          end
                        }
                        size={:xs}
                        color={:light_gray}
                        class="!text-sm"
                      />
                      <span class="hidden lg:flex lg:items-center">
                        <span class="text-sm font-semibold leading-6 text-zinc-900" aria-hidden="true"><%= @current_user.name %></span>
                        <.icon name={:chevron_right} solid class="h-5 w-5 text-zinc-400" />
                      </span>
                    </button>
                  </:wrapper>
                </.dropdown>
              </li>
            <% else %>
              <div class="mt-auto border-b border-zinc-200"></div>
              <li class="-mx-6 flex items-center px-6 pb-3">
                <%= live_redirect to: Routes.user_session_path(AtomicWeb.Endpoint, :new), class: "text-md font-semibold leading-6 text-zinc-900 hover:underline" do %>
                  Sign in <span aria-hidden="true">&rarr;</span>
                <% end %>
              </li>
            <% end %>
          </ul>
        </nav>
      </div>
    </div>
    """
  end

  defp dropdown_items(current_user) do
    [
      %{
        name: gettext("Your profile"),
        navigate: Routes.profile_show_path(AtomicWeb.Endpoint, :show, current_user)
      },
      %{
        name: gettext("Sign out"),
        href: Routes.user_session_path(AtomicWeb.Endpoint, :delete),
        method: "delete"
      }
    ]
  end
end
