defmodule AtomicWeb.Components.Socials do
  @moduledoc false

  use AtomicWeb, :component

  attr :entity, :map, required: true

  def socials(assigns) do
    assigns = assign(assigns, :socials_with_values, get_social_values(assigns.entity))

    ~H"""
    <div class="grid grid-cols-2 gap-2 md:flex md:flex-row">
      <%= for {social, icon, url_base, social_value} <- assigns.socials_with_values do %>
        <%= if social_value do %>
          <div class="flex flex-row items-center gap-x-2">
            <img src={"/images/" <> icon} class="h-5 w-5" alt={Atom.to_string(social)} />
            <.link class="capitalize text-blue-500" target="_blank" href={url_base <> social_value}>
              <%= Atom.to_string(social) %>
            </.link>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp get_social_values(entity) do
    socials = Map.get(entity, :socials, %{})

    get_socials()
    |> Enum.map(fn {social, icon, url_base} ->
      social_value = Map.get(socials, social)
      {social, icon, url_base, social_value}
    end)
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
