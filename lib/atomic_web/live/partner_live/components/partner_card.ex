defmodule AtomicWeb.PartnerLive.Components.PartnerCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Gradient}

  def partner_card(assigns) do
    ~H"""
          <li class="px-4 h-full flex flex-col md:flex-row justify-between rounded-lg border border-zinc-200 hover:bg-zinc-50 gap-x-6 py-5">
            <div class="h-14 w-full object-cover">
              <%= if @partner.banner do %>
                <img class="h-14 w-full rounded-t-lg object-cover" src={Uploaders.Banner.url({@partner.banner, @partner}, :original)} />
              <% else %>
                <.gradient seed={@partner.id} class="rounded-t-lg" />
              <% end %>
            </div>
            <div class="flex flex-col md:flex-row gap-x-4 w-full">
              <div class="flex-shrink-0">
                <.avatar color={:light_gray} name={partner.name} src={Uploaders.PartnerImage.url({partner.image, partner}, :original)} type={:company} size={:sm} />
              </div>
              <div class="flex-grow flex-col">
                <p class="text-md font-semibold leading-6 text-zinc-900"><%= partner.name %></p>
                <%= if partner.location do %>
                  <div class="flex flex-row items-center gap-x-1 text-sm leading-6 z-1">
                    <.icon name={:map_pin} class="h-4 w-4 my-1 text-zinc-400" />
                    <p class="text-blue-400 text-xs"><%= partner.location.name %></p>
                  </div>
                <% end %>
                <p class="mt-1 truncate text-xs leading-5 text-zinc-500 overflow-hidden overflow-ellipsis whitespace-normal">
                  <%= Enum.map(String.split(partner.benefits, "\n"), fn phrase -> %>
                    <%= if String.length(phrase) < 100 do %>
                      <%= phrase %><br />
                    <% else %>
                      <%= String.slice(phrase, 0..100) <> "..." %> <br />
                    <% end %>
                  <% end) %>
                </p>
              </div>
            </div>
          </li>
    """
  end
end
