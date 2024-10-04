defmodule AtomicWeb.Components.Socials do
  @moduledoc false
  use Phoenix.Component

  def socials(assigns) do
    social_links = [
      {:tiktok, "tiktok.svg", "https://tiktok.com/"},
      {:instagram, "instagram.svg", "https://instagram.com/"},
      {:facebook, "facebook.svg", "https://facebook.com/"},
      {:x, "x.svg", "https://x.com/"}
    ]

    ~H"""
    <%= if @entity.socials do %>
      <div class="mt-4 flex gap-4">
        <%= for {social, icon, url_base} <- social_links do %>
          <% social_value = Map.get(@entity.socials, social) %>
          <%= if social_value do %>
            <div class="flex flex-row items-center gap-x-1">
              <img src={"/images/" <> icon} class="h-5 w-5" alt={social |> Atom.to_string() |> String.capitalize()} />
              <.link class="text-blue-500" target="_blank" href={url_base <> social_value}>
                <%= social |> Atom.to_string() |> String.capitalize() %>
              </.link>
            </div>
          <% end %>
        <% end %>
      </div>
    <% end %>
    """
  end
end
