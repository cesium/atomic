defmodule AtomicWeb.Components.Socials do
  @moduledoc false
  use Phoenix.Component
  alias AtomicWeb.Components.Helpers

  attr :entity, :map, required: true

  def socials(assigns) do
    assigns = assign(assigns, :socials_with_values, get_social_values(assigns.entity))

    ~H"""
    <div class="mt-4 flex gap-4">
      <%= for {social, icon, url_base, social_value} <- @socials_with_values do %>
        <%= if social_value do %>
          <div class="flex flex-row items-center gap-x-1">
            <img src={"/images/" <> icon} class="h-5 w-5" alt={Helpers.atom_to_string_capitalize(social)} />
            <.link class="text-blue-500" target="_blank" href={url_base <> social_value}>
              <%= Helpers.atom_to_string_capitalize(social) %>
            </.link>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp get_social_values(entity) do
    get_socials()
    |> Enum.map(fn {social, icon, url_base} ->
      social_value = Map.get(entity, social)
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
