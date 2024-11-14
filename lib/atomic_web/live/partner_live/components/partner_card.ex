defmodule AtomicWeb.PartnerLive.Components.PartnerCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Gradient}

  attr :partner, :map, required: true

  def partner_card(assigns) do
    ~H"""
          <li class="gap-x-6 h-full w-full grid rounded-lg border border-zinc-200 hover:bg-zinc-50 ">
            <div class="h-20 w-full">
              <div class="h-16 w-full">
                <.gradient seed={@partner.id} class="rounded-t-lg" />
              </div> 
              <div class="flex justify-center relative bottom-20">
                <.avatar color={:light_gray} name={@partner.name} class="size-28 object-cover" src={Uploaders.PartnerImage.url({@partner.image, @partner}, :original)} type={:company} size={:sm} />
              </div>
            </div>
            <div class="flex flex-col mt-8 md:flex-row gap-x-4 w-full px-12">
              <div class="flex-grow flex-col justify-center items-center">
                <p class="text-md text-lg font-semibold leading-6 text-center text-zinc-900"><%= @partner.name %></p>
                <%= if @partner.location do %>
                  <div class="flex justify-center items-center gap-x-1 leading-6 z-1">
                    <.icon name={:map_pin} class="h-4 w-4 my-1 text-zinc-400" />
                    <p class="text-blue-400 text-center text-sm"><%= @partner.location.name %></p>
                  </div>
                <% end %>
                <div>
                  <p class="mt-5 mb-10 truncate text-xs leading-5 text-zinc-500 overflow-hidden overflow-ellipsis whitespace-normal">
                    <%= Enum.map(String.split(@partner.benefits, "\n"), fn phrase -> %>
                      <%= if String.length(phrase) < 75 do %>
                        <%= phrase %><br />
                      <% else %>
                        <%= String.slice(phrase, 0..75) <> "..." %> <br />
                      <% end %>
                    <% end) %>
                  </p>
                </div>
              </div>
            </div>
          </li>
    """
  end
end
