defmodule AtomicWeb.PartnerLive.Components.PartnerCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Gradient}

  attr :partner, :map, required: true

  def partner_card(assigns) do
    ~H"""
    <li class="grid h-full w-full rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="h-12 w-full">
        <div class="h-full w-full">
          <.gradient seed={@partner.id} class="rounded-t-lg" />
        </div>
      </div>

      <div class="grid w-full">
        <div class="flex flex-grow px-6">
          <div class="relative bottom-6 flex">
            <.avatar color={:light_zinc} class="" name={@partner.name} src={Uploaders.PartnerImage.url({@partner.image, @partner}, :original)} type={:company} size={:xl} />
          </div>
          <div class="mt-5 px-4">
            <div class="group relative">
              <p class="text-md line-clamp-1 text-lg font-semibold leading-6 text-zinc-900">{@partner.name}</p>
              <div class="absolute top-full left-14 mt-2 hidden w-max rounded bg-gray-500 p-1 text-sm text-white opacity-100 transition-opacity duration-300 group-hover:block">{@partner.name}</div>
              <div class="absolute top-full left-16 mt-1 hidden border-r-4 border-b-4 border-l-4 border-r-transparent border-b-gray-500 border-l-transparent group-hover:block"></div>
            </div>
            <%= if @partner.location do %>
              <div class="z-1 flex items-center gap-x-1 leading-6">
                <.icon name="hero-map-pin" class="my-1 h-4 w-4 text-zinc-400" />
                <p class="text-center text-sm text-blue-400">{@partner.location.name}</p>
              </div>
            <% end %>
          </div>
        </div>
        <div>
          <p class="overflow-hidden truncate overflow-ellipsis whitespace-normal px-10 pb-10 text-xs leading-5 text-zinc-500">
            <%= Enum.map(String.split(@partner.benefits, "\n"), fn phrase -> %>
              <%= if String.length(phrase) < 50 do %>
                {phrase}<br />
              <% else %>
                {String.slice(phrase, 0..50) <> "..."} <br />
              <% end %>
            <% end) %>
          </p>
        </div>
      </div>
    </li>
    """
  end
end
