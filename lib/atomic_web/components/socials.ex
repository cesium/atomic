defmodule AtomicWeb.Components.Socials do
  @moduledoc false
  use Phoenix.Component

  attr :socials, :map, required: true
  attr :entity, :map, required: true

  def socials(assigns) do
    ~H"""
    <div class="mt-4 flex gap-4">
      <%= for {social, icon, url_base} <- get_socials() do %>
        <% social_value = Map.get(@entity, social) %>
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
    """
  end

  def get_socials do
    [
      {:tiktok, "tiktok.svg", "https://tiktok.com/"},
      {:instagram, "instagram.svg", "https://instagram.com/"},
      {:facebook, "facebook.svg", "https://facebook.com/"},
      {:x, "x.svg", "https://x.com/"}
    ]
  end
end
