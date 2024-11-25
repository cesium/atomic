defmodule AtomicWeb.PartnerLive.Components.PartnerCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Gradient}

  attr :partner, :map, required: true

  def partner_card(assigns) do
    ~H"""
          <li class="h-full w-full grid rounded-lg border border-zinc-200 hover:bg-zinc-50 ">
            <div class="h-12 w-full">
              <div class="h-full w-full">
                <.gradient seed={@partner.id} class="rounded-t-lg" />
              </div> 
            </div>

            <div class="grid w-full">
              <div class="flex flex-grow px-6">
                <div class="flex relative bottom-6">
                  <.avatar color={:light_gray} class="" name={@partner.name} src={Uploaders.PartnerImage.url({@partner.image, @partner}, :original)} type={:company} size={:xl} />
                </div>
                <div class="px-4 mt-5">
                  <div class="relative group ">
                    <p class="text-md text-lg line-clamp-1 font-semibold leading-6 text-zinc-900"><%= @partner.name %></p>
                    <div class="absolute top-full w-max left-14 mt-2 hidden rounded bg-gray-500 text-white text-sm p-1 group-hover:block opacity-100 transition-opacity duration-300"><%= @partner.name %></div>
                    <div class="absolute top-full left-16 mt-1 hidden group-hover:block border-l-4 border-r-4 border-b-4 border-l-transparent border-r-transparent border-b-gray-500"></div>
                  </div>
                  <%= if @partner.location do %>
                    <div class="flex items-center gap-x-1 leading-6 z-1">
                      <.icon name="hero-map-pin" class="h-4 w-4 my-1 text-zinc-400" />
                      <p class="text-blue-400 text-center text-sm"><%= @partner.location.name %></p>
                    </div>
                  <% end %>
                </div>
              </div>
              <div>
                <p class="pb-10 px-10 truncate text-xs leading-5 text-zinc-500 overflow-hidden overflow-ellipsis whitespace-normal">
                  <%= Enum.map(String.split(@partner.benefits, "\n"), fn phrase -> %>
                    <%= if String.length(phrase) < 50 do %>
                      <%= phrase %><br />
                    <% else %>
                      <%= String.slice(phrase, 0..50) <> "..." %> <br />
                    <% end %>
                  <% end) %>
                </p>
              </div>
            </div>
          </li>
    """
  end
end
